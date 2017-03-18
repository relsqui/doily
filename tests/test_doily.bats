#!/usr/bin/env bats

load helpers
XDG_CONFIG_HOME="${BATS_TMPDIR}/home"

setup() {
    # This will be the parent directory for the config file.
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "config exists" {
    mkdir -p "${XDG_CONFIG_HOME}/.config/doily/"
    touch "${XDG_CONFIG_HOME}/.config/doily/doily.conf"
    check_config
}
