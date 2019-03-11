/// Analyzes a subroutine and returns all the `BL` and `B` instructions in it, plus whether this
/// function performs an indirect function call or not
// NOTE we assume that `bytes` is always valid input so all errors are bugs
// Reference: ARMv7-M Architecture Reference Manual
// TODO remove all `eprintln!`
pub fn analyze(
    bytes: &[u8],
    address: u32,
    v7: bool,
    tags: &[(u32, Tag)],
) -> (Vec<i32>, Vec<i32>, bool) {
    macro_rules! bug {
        ($first:expr) => {
            panic!(
                "BUG: unknown instruction {:02x}{:02x}",
                $first[1], $first[0]
            );
        };

        ($first:expr, $second:expr) => {
            panic!(
                "BUG: unknown instruction {:02x}{:02x} {:02x}{:02x}",
                $first[1], $first[0], $second[1], $second[0]
            );
        };
    }

    // we want to avoid writing a full blown decoder since we are only interested in a single type
    // of instruction. We know that instructions can be 16-bit or 32-bit so we'll only decode 16-bit
    // instructions and assume that the rest are 32-bit instructions.
    // NOTE this implementation has been optimized to be easy to write, not to be high-performance
    let mut bls = vec![];
    let mut bs = vec![];
    let mut indirect = false;
    let mut halfwords = bytes.chunks_exact(2).zip(0i32..);
    while let Some((first, i)) = halfwords.next() {
        let start = address + 2 * i as u32;
        if let Ok(needle) = tags.binary_search_by(|(addr, _)| addr.cmp(&start)) {
            if tags[needle].1 == Tag::Data {
                // start of a data section

                if let Some(tag) = tags.get(needle + 1) {
                    assert_eq!(
                        tag.1,
                        Tag::Thumb,
                        "BUG: expected a thumb tag at {:#10x} but found another data tag",
                        tag.0
                    );

                    // skip the data section
                    let end = tag.0;
                    // NOTE the range starts at 1 because we'll skip `first` using the `continue`
                    // that comes after this `for` loop
                    for _ in 1..(end - start) / 2 {
                        halfwords.next();
                    }

                    continue;
                } else {
                    // continues until the end of the binary; we won't find more instructions so
                    // let's stop decoding
                    break;
                }
            }
        }

        if matches(first, "0b010000_0101_xxx_xxx") {
            // A7.7.2 ADC (register) - T1
            continue;
        } else if matches(first, "0b000_11_1_0_xxx_xxx_xxx") {
            // A7.7.3 ADD (immediate) - T1
            continue;
        } else if matches(first, "0b001_10_xxx_xxxxxxxx") {
            // A7.7.3 ADD (immediate) - T2
            continue;
        } else if matches(first, "0b000_11_0_0_xxx_xxx_xxx") {
            // A7.7.4 ADD (register) - T1
            continue;
        } else if matches(first, "0b010001_00_x_xxxx_xxx") {
            // A7.7.4 ADD (register) - T2
            continue;
        } else if matches(first, "0b1010_1_xxx_xxxxxxxx") {
            // A7.7.5  ADD (SP plus immediate) - T1
            continue;
        } else if matches(first, "0b1011_0000_0_xxxxxxx") {
            // A7.7.5  ADD (SP plus immediate) - T2
            continue;
        } else if matches(first, "0b01000100_x_1101_xxx") {
            // A7.7.6  ADD (SP plus register) - T1
            continue;
        } else if matches(first, "0b01000100_1_xxxx_101") {
            // A7.7.6  ADD (SP plus register) - T2
            continue;
        } else if matches(first, "0b1010_0_xxx_xxxxxxxx") {
            // A7.7.7  ADR - T1
            continue;
        } else if matches(first, "0b010000_0000_xxx_xxx") {
            // A7.7.9  AND (register) - T1
            continue;
        } else if matches(first, "0b000_10_xxxxx_xxx_xxx") {
            // A7.7.10  ASR (immediate) - T1
            continue;
        } else if matches(first, "0b010000_0100_xxx_xxx") {
            // A7.7.11  ASR (register) - T1
            continue;
        } else if v7 && matches(first, "0b1101_1110_xxxxxxxx") {
            // NOTE we break the alphabetical order because the rule for `B` overlaps with the rule
            // for `UDF` but `UDF` takes precedence
            // A7.7.191      UDF - T1
            continue;
        } else if matches(first, "0b1101_1111_xxxxxxxx") {
            // NOTE we break the alphabetical order because the rule for `B` overlaps with the rule
            // for `SVC` but `SVC` takes precedence
            // A7.7.175      SVC - T1
            continue;
        } else if matches(first, "0b1101_xxxx_xxxxxxxx") {
            // A7.7.12  B - T1
            let cond = first[1] & 0b1111;
            assert_ne!(cond, 0b1110); // UDF
            assert_ne!(cond, 0b1111); // SVC
            let imm8 = first[0] as i32;
            let mut imm32 = sign_extend(imm8 << 1, 9);

            // offset is computed from the address of the *next* instruction; adjust
            // accordingly
            // (it's unclear to me why this needs to be `4` instead of `2` but that's what works)
            imm32 += 2 * i + 4;

            bs.push(imm32);
        } else if matches(first, "0b11100_xxxxxxxxxxx") {
            // A7.7.12  B - T2
            let imm11 = (i32::from(first[1] & 0b111) << 8) | first[0] as i32;
            let mut imm32 = sign_extend(imm11 << 1, 12);

            // offset is computed from the address of the *next* instruction; adjust
            // accordingly
            // (it's unclear to me why this needs to be `4` instead of `2` but that's what works)
            imm32 += 2 * i + 4;

            bs.push(imm32);
        } else if matches(first, "0b010000_1110_xxx_xxx") {
            // A7.7.16  BIC (register) - T1
            continue;
        } else if matches(first, "0b1010_1110_xxxxxxxx") {
            // A7.7.17  BKPT - T1
            continue;
        } else if matches(first, "0b010001_11_1_xxxx_000") {
            // A7.7.19  BLX (register) - T1
            indirect = true;
        } else if matches(first, "0b010001_11_0_xxxx_000") {
            // A7.7.20  BX - T1
            let rm = (first[0] >> 3) & 0b1111;

            // `bx lr` is just a `return`
            if rm != 0b1110 {
                indirect = true;
            }
        } else if v7 && matches(first, "0b1011_x_0_x_1_xxxxx_xxx") {
            // A7.7.21  CBNZ, CBZ - T1
            continue;
        } else if matches(first, "0b010000_1011_xxx_xxx") {
            // A7.7.26  CMN (register) - T1
            continue;
        } else if matches(first, "0b001_01_xxx_xxxxxxxx") {
            // A7.7.27  CMP (immediate) - T1
            continue;
        } else if matches(first, "0b010000_1010_xxx_xxx") {
            // A7.7.28  CMP (register) - T1
            continue;
        } else if matches(first, "0b010001_01_x_xxxx_xxx") {
            // A7.7.28  CMP (register) - T2
            continue;
        } else if matches(first, "0b1011_0110_011_x_00_xx") {
            // A7.7.29  CPS - T1
            continue;
        } else if matches(first, "0b010000_0001_xxx_xxx") {
            // A7.7.35  EOR (register) - T1
            continue;
        } else if v7 && matches(first, "0b1011_1111_xxxx_xxxx") {
            // A7.7.37  IT - T1
            continue;
        } else if matches(first, "0b1100_1_xxx_xxxxxxxx") {
            // A7.7.40  LDM, LDMIA, LDMFD - T1
            continue;
        } else if matches(first, "0b011_0_1_xxxxx_xxx_xxx") {
            // A7.7.42  LDR (immediate) - T1
            continue;
        } else if matches(first, "0b1001_1_xxx_xxxxxxxx") {
            // A7.7.42  LDR (immediate) - T2
            continue;
        } else if matches(first, "0b01001_xxx_xxxxxxxx") {
            // A7.7.43  LDR (literal) - T1
            continue;
        } else if matches(first, "0b0101_100_xxx_xxx_xxx") {
            // A7.7.44  LDR (register) - T1
            continue;
        } else if matches(first, "0b011_1_1_xxxxx_xxx_xxx") {
            // A7.7.45  LDRB (immediate) - T1
            continue;
        } else if matches(first, "0b0101_110_xxx_xxx_xxx") {
            // A7.7.47  LDRB (register) - T1
            continue;
        } else if matches(first, "0b1000_1_xxxxx_xxx_xxx") {
            // A7.7.54  LDRH (immediate) - T1
            continue;
        } else if matches(first, "0b0101_101_xxx_xxx_xxx") {
            // A7.7.56  LDRH (register) - T1
            continue;
        } else if matches(first, "0b0101_011_xxx_xxx_xxx") {
            // A7.7.60  LDRSB (register) - T1
            continue;
        } else if matches(first, "0b0101_111_xxx_xxx_xxx") {
            // A7.7.64  LDRSH (register) - T1
            continue;
        } else if matches(first, "0b000_00_xxxxx_xxx_xxx") {
            // A7.7.67  LSL (immediate) - T1
            continue;
        } else if matches(first, "0b010000_0010_xxx_xxx") {
            // A7.7.68  LSL (register) - T1
            continue;
        } else if matches(first, "0b000_01_xxxxx_xxx_xxx") {
            // A7.7.69  LSR (immediate) - T1
            continue;
        } else if matches(first, "0b010000_0011_xxx_xxx") {
            // A7.7.70  LSR (register) - T1
            continue;
        } else if matches(first, "0b001_00_xxx_xxxxxxxx") {
            // A7.7.75  MOV (immediate) - T1
            continue;
        } else if matches(first, "0b010001_10_x_xxxx_xxx") {
            // A7.7.76  MOV (register) - T1
            continue;
        } else if matches(first, "0b000_00_00000_xxx_xxx") {
            // A7.7.76  MOV (register) - T2
            continue;
        } else if matches(first, "0b010000_1101_xxx_xxx") {
            // A7.7.83  MUL - T1
            continue;
        } else if matches(first, "0b010000_1111_xxx_xxx") {
            // A7.7.85  MVN (register) - T1
            continue;
        } else if v7 && matches(first, "0b1011_1111_0000_0000") {
            // A7.7.87  NOP - T1
            continue;
        } else if matches(first, "0b010000_1100_xxx_xxx") {
            // A7.7.91  ORR (register) - T1
            continue;
        } else if matches(first, "0b1011_1_10_x_xxxxxxxx") {
            // A7.7.98  POP - T1
            continue;
        } else if matches(first, "0b1011_0_10_x_xxxxxxxx") {
            // A7.7.99  PUSH - T1
            continue;
        } else if matches(first, "0b1011_1010_00_xxx_xxx") {
            // A7.7.111  REV - T1
            continue;
        } else if matches(first, "0b1011_1010_01_xxx_xxx") {
            // A7.7.112      REV16 - T1
            continue;
        } else if matches(first, "0b1011_1010_11_xxx_xxx") {
            // A7.7.113      REVSH - T1
            continue;
        } else if matches(first, "0b010000_0111_xxx_xxx") {
            // A7.7.115      ROR (register) - T1
            continue;
        } else if matches(first, "0b010000_1001_xxx_xxx") {
            // A7.7.117  RSB (immediate) - T1
            continue;
        } else if matches(first, "0b010000_0110_xxx_xxx") {
            // A7.7.123      SBC (register) - T1
            continue;
        } else if matches(first, "0b1011_1111_0100_0000") {
            // A7.7.127      SEV - T1
            continue;
        } else if matches(first, "0b1100_0_xxx_xxxxxxxx") {
            // A7.7.156      STM, STMIA, STMEA - T1
            continue;
        } else if matches(first, "0b011_0_0_xxxxx_xxx_xxx") {
            // A7.7.158      STR (immediate) - T1
            continue;
        } else if matches(first, "0b1001_0_xxx_xxxxxxxx") {
            // A7.7.158      STR (immediate) - T2
            continue;
        } else if matches(first, "0b0101_000_xxx_xxx_xxx") {
            // A7.7.159      STR (register) - T1
            continue;
        } else if matches(first, "0b011_1_0_xxxxx_xxx_xxx") {
            // A7.7.160      STRB (immediate) - T1
            continue;
        } else if matches(first, "0b0101_010_xxx_xxx_xxx") {
            // A7.7.161      STRB (register) - T1
            continue;
        } else if matches(first, "0b1000_0_xxxxx_xxx_xxx") {
            // A7.7.167      STRH (immediate) - T1
            continue;
        } else if matches(first, "0b0101_001_xxx_xxx_xxx") {
            // A7.7.168      STRH (register) - T1
            continue;
        } else if matches(first, "0b000_11_1_1_xxx_xxx_xxx") {
            // A7.7.171      SUB (immediate) - T1
            continue;
        } else if matches(first, "0b001_11_xxx_xxxxxxxx") {
            // A7.7.171      SUB (immediate) - T2
            continue;
        } else if matches(first, "0b000_11_0_1_xxx_xxx_xxx") {
            // A7.7.172      SUB (register) - T1
            continue;
        } else if matches(first, "0b1011_0000_1_xxxxxxx") {
            // A7.7.173      SUB (SP minus immediate) - T1
            continue;
        } else if matches(first, "0b1011_0010_01_xxx_xxx") {
            // A7.7.179      SXTB - T1
            continue;
        } else if matches(first, "0b1011_0010_00_xxx_xxx") {
            // A7.7.181      SXTH - T1
            continue;
        } else if matches(first, "0b010000_1000_xxx_xxx") {
            // A7.7.186      TST (register) - T1
            continue;
        } else if matches(first, "0b1011_0010_11_xxx_xxx") {
            // A7.7.218      UXTB - T1
            continue;
        } else if matches(first, "0b1011_0010_10_xxx_xxx") {
            // A7.7.220      UXTH - T1
            continue;
        } else if matches(first, "0b1011_1111_0010_0000") {
            // A7.7.258      WFE - T1
            continue;
        } else if matches(first, "0b1011_1111_0011_0000") {
            // A7.7.259      WFI - T1
            continue;
        } else if matches(first, "0b1011_1111_0001_0000") {
            // A7.7.260      YIELD - T1
            continue;
        } else {
            let second = halfwords.next().unwrap_or_else(|| bug!(first)).0;

            if v7
                && matches(first, "0b11110_x_xxxxxxxxxx")
                && matches(second, "0b10_x_0_x_xxxxxxxxxxx")
            {
                // A7.7.12  B - T3

                let cond = ((first[1] & 0b11) << 2) | (first[0] >> 6);
                if cond >> 1 == 0b111 {
                    // MSR instruction
                    continue;
                }

                let s = (first[1] >> 2) & 1 == 1;
                let imm6 = (first[0] & 0b111111) as i32;
                let j1 = second[1] & (1 << 5) != 0;
                let j2 = second[1] & (1 << 3) != 0;
                let imm11 = (i32::from(second[1] & 0b111) << 8) | second[0] as i32;
                let imm21 = (if s { 1 } else { 0 } << 20)
                    | (if j1 { 1 } else { 0 } << 19)
                    | (if j2 { 1 } else { 0 } << 18)
                    | (imm6 << 12)
                    | (imm11 << 1);

                let mut imm32 = sign_extend(imm21, 21);

                // offset is computed from the address of the *next* instruction; adjust
                // accordingly
                imm32 += 2 * i + 4;

                bs.push(imm32);
            } else if v7
                && matches(first, "0b11110_x_xxxxxxxxxx")
                && matches(second, "0b10_x_1_x_xxxxxxxxxxx")
            {
                // A7.7.12  B - T4

                let s = (first[1] >> 2) & 1 == 1;
                let imm10 = (i32::from(first[1] & 0b11) << 8) + first[0] as i32;
                let j1 = second[1] & (1 << 5) != 0;
                let j2 = second[1] & (1 << 3) != 0;
                let imm11 = (i32::from(second[1] & 0b111) << 8) + second[0] as i32;

                let i1 = if !(j1 ^ s) { 1 } else { 0 };
                let i2 = if !(j2 ^ s) { 1 } else { 0 };

                let imm25 = (if s { 1 } else { 0 } << 24)
                    | (i1 << 23)
                    | (i2 << 22)
                    | (imm10 << 12)
                    | (imm11 << 1);

                let mut imm32 = sign_extend(imm25, 25);

                // offset is computed from the address of the *next* instruction; adjust
                // accordingly
                imm32 += 2 * i + 4;

                bs.push(imm32);
            } else if matches(first, "0b11110_x_xxxxxxxxxx")
                && matches(second, "0b11_x_1_x_xxxxxxxxxxx")
            {
                // A7.7.18  BL - T1

                let s = (first[1] >> 2) & 1 == 1;
                let imm10 = (i32::from(first[1] & 0b11) << 8) | i32::from(first[0]);
                let j1 = (second[1] & (1 << 5)) == 1 << 5;
                let j2 = (second[1] & (1 << 3)) == 1 << 3;
                let imm11 = (i32::from(second[1] & 0b111) << 8) | i32::from(second[0]);

                let i1 = if !(j1 ^ s) { 1 } else { 0 };
                let i2 = if !(j2 ^ s) { 1 } else { 0 };
                let imm25 = (if s { 1 } else { 0 } << 24)
                    | (i1 << 23)
                    | (i2 << 22)
                    | (imm10 << 12)
                    | (imm11 << 1);

                let mut imm32 = sign_extend(imm25, 25);

                // offset is computed from the address of the *next* instruction; adjust
                // accordingly
                imm32 += 2 * i + 4;

                bls.push(imm32);
            } else {
                // some other 32-bit instruction
                continue;
            }
        }
    }

    (bls, bs, indirect)
}

fn matches(bytes: &[u8], pattern: &str) -> bool {
    assert!(pattern.starts_with("0b"));

    let pattern = pattern[2..].replace("_", "");
    assert_eq!(pattern.len(), 16);

    let mask1 =
        u8::from_str_radix(&pattern[..8].replace("0", "1").replace("x", "0"), 2).expect("BUG");
    let value1 = u8::from_str_radix(&pattern[..8].replace("x", "0"), 2).expect("BUG");

    let mask2 =
        u8::from_str_radix(&pattern[8..].replace("0", "1").replace("x", "0"), 2).expect("BUG");
    let value2 = u8::from_str_radix(&pattern[8..].replace("x", "0"), 2).expect("BUG");

    let first = bytes[1];
    let second = bytes[0];
    (first & mask1 == value1) && (second & mask2 == value2)
}

fn sign_extend(x: i32, nbits: u32) -> i32 {
    let shift = 32 - nbits;
    x.wrapping_shl(shift).wrapping_shr(shift)
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Tag {
    // symbol with name `$d.123` used as a tag
    Data,

    // symbol with name `$t.123` used as a tag
    Thumb,
}

#[cfg(test)]
mod tests {
    #[test]
    fn sanity() {
        assert_eq!(
            super::analyze(&[0xff, 0xf7, 0xe4, 0xfe], 0, false, &[]).0,
            vec![-568 + 4]
        );

        assert_eq!(
            super::analyze(&[0x00, 0xf0, 0x2a, 0xfa], 0, false, &[]).0,
            vec![1108 + 4]
        );

        assert_eq!(
            super::analyze(&[0x03, 0xe2], 0, false, &[]).1,
            vec![1030 + 4]
        );

        // UDF
        assert_eq!(
            super::analyze(&[0xfe, 0xde], 0, true, &[]),
            (vec![], vec![], false)
        );
    }
}
