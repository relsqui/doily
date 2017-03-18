assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

# This will be the parent directory for the config file.
XDG_CONFIG_HOME="${BATS_TMPDIR}/doily/config_home"
DOILY_TEST_ETC="${BATS_TMPDIR}/doily/etc"
DOILY_TEST_BIN="${BATS_TMPDIR}/doily/bin"
personal_config="${XDG_CONFIG_HOME}/doily/doily.conf"
global_config="${DOILY_TEST_ETC}/doily/default.conf"
testbin="${BATS_TMPDIR}/doily/testbin"
mkdir -p "${testbin}"
PATH="${PATH}:${testbin}"
