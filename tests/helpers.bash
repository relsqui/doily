assertFails() {
    # Convenience function for verifying failure of a command.
    run "$@" >&2
    test "${status}" -ne 0
}

# We use temp space for a lot of things.
export DOILY_TMP="${BATS_TMPDIR}/doily"

# Putting a homedir in our temp space makes it easier to clean up.
export HOME="${DOILY_TMP}/home"
mkdir -p "${HOME}"

# Systemwide locations for the binary and default config.
export DOILY_TEST_ETC="${DOILY_TMP}/etc"
export DOILY_TEST_BIN="${DOILY_TMP}/bin"
export PATH="${DOILY_TEST_BIN}:${PATH}"

# Convenience shortcuts.
export PERSONAL_CONFIG_DIR="${HOME}/.config/doily"
export DEFAULT_CONFIG_DIR="${DOILY_TEST_ETC}/doily/"
export PERSONAL_CONFIG="${HOME}/.config/doily/doily.conf"
export DEFAULT_CONFIG="${DOILY_TEST_ETC}/doily/default.conf"

# For tests which need to create auxiliary scripts.
export DOILY_TMP_BIN="${DOILY_TMP}/tmp_bin"
mkdir -p "${DOILY_TMP_BIN}"
export PATH="${DOILY_TMP_BIN}:${PATH}"
