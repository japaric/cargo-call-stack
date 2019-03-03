set -euxo pipefail

main() {
    # it compiles
    cargo check

    # it passes the parser test suite
    cargo test

    # it can analyze "Hello, world!"
    cargo install --path . -f --debug

    local td=$(mktemp -d)
    pushd $td
    cargo init --name hello
    cargo call-stack --bin hello > /dev/null
    popd

    rm -rf $td
}

main
