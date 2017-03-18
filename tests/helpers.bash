assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

# We use temp space for a lot of things.
export DOILY_TMP="${BATS_TMPDIR}/doily"

# This will be the parent directory for personal config.
export HOME="${DOILY_TMP}/home"

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

export SAMPLE_CONF="${DOILY_TMP}/default.conf"
cat > "${SAMPLE_CONF}" <<EOF
public_dailies=
doily_group=
use_git=
auto_commit=y
doily_dir="\${XDG_DATA_HOME:-\$HOME/.local/share}/doily/dailies"
EOF
