################################################################################
# Doily test helpers.
#
# (c) 2017 Finn Ellis.
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
#
# This file is intended to be included, with `load`, at the top of a Bats test
# file. It sets up some temporary workspace and provides convenience functions
# and constants to make it easy to track of which files are where in tests.
################################################################################

assertFails() {
    # Convenience function for verifying failure of a command.
    run "$@" >&2
    test "${status}" -ne 0
}

teardown() {
    # Remove files in the test workspace between tests.
    rm -rf "${DOILY_TMP}"
}

# Define a temporary workspace for files generated in tests.
export DOILY_TMP="${BATS_TMPDIR}/doily"

# Putting a homedir in our temp space makes it easier to clean up.
export HOME="${DOILY_TMP}/home"
mkdir -p "${HOME}"

# Locations for the systemwide binary and default config.
export DOILY_TEST_ETC="${DOILY_TMP}/etc"
export DOILY_TEST_BIN="${DOILY_TMP}/bin"
export PATH="${DOILY_TEST_BIN}:${PATH}"

# Convenience shortcuts.
export PERSONAL_CONFIG_DIR="${HOME}/.config/doily"
export DEFAULT_CONFIG_DIR="${DOILY_TEST_ETC}/doily/"
export PERSONAL_CONFIG="${HOME}/.config/doily/doily.conf"
export DEFAULT_CONFIG="${DOILY_TEST_ETC}/doily/default.conf"
