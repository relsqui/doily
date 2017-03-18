assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

# We use temp space for a lot of things.
DOILY_TMP="${BATS_TMPDIR}/doily"

# This will be the parent directory for personal config.
XDG_CONFIG_HOME="${DOILY_TMP}/config_home"

# Systemwide locations for the binary and default config.
DOILY_TEST_BIN="${DOILY_TMP}/bin"
DOILY_TEST_ETC="${DOILY_TMP}/etc"

# Convenience shortcuts.
personal_config="${XDG_CONFIG_HOME}/doily/doily.conf"
global_config="${DOILY_TEST_ETC}/doily/default.conf"

# For tests which need to create auxiliary scripts.
testbin="${DOILY_TMP}/testbin"
mkdir -p "${testbin}"
PATH="${testbin}:${PATH}"
