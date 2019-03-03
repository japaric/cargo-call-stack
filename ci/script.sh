set -euxo pipefail

main() {
    # it compiles and passes the parser test suite
    cargo test

    # it can analyze "Hello, world!"
    cargo install --path . -f --debug

    if [ $TRAVIS_RUST_VERSION = nightly ]; then
        local td=$(mktemp -d)
        pushd $td
        cargo init --name hello
        cargo call-stack --bin hello > /dev/null
        popd

        rm -rf $td
    fi
}

# fake Travis variables to be able to run this on a local machine
if [ -z ${TRAVIS_RUST_VERSION-} ]; then
    case $(rustc -V) in
        *nightly*)
            TRAVIS_RUST_VERSION=nightly
            ;;
        *beta*)
            TRAVIS_RUST_VERSION=beta
            ;;
        *)
            TRAVIS_RUST_VERSION=stable
            ;;
    esac
fi

main
