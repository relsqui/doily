assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

# We use temp space for a lot of things.
export DOILY_TMP="${BATS_TMPDIR}/doily"

# This will be the parent directory for personal config.
export HOME="${DOILY_TMP}/home"
export XDG_CONFIG_HOME="${DOILY_TMP}/home/.config"

# Systemwide locations for the binary and default config.
export DOILY_TEST_ETC="${DOILY_TMP}/etc"
export DOILY_TEST_BIN="${DOILY_TMP}/bin"
export PATH="${DOILY_TEST_BIN}:${PATH}"

# Convenience shortcuts.
export personal_config="${XDG_CONFIG_HOME}/doily/doily.conf"
export global_config="${DOILY_TEST_ETC}/doily/default.conf"

# For tests which need to create auxiliary scripts.
export testbin="${DOILY_TMP}/testbin"
mkdir -p "${testbin}"
export PATH="${testbin}:${PATH}"

export SAMPLE_CONF="${DOILY_TMP}/default.conf"
cat > "${SAMPLE_CONF}" <<EOF
public_dailies=
doily_group=
use_git=
auto_commit=y
doily_dir="${XDG_DATA_HOME:-$HOME/.local/share}/doily/dailies"
EOF
