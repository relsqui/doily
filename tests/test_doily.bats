#!/usr/bin/env bats

load helpers

setup() {
    # This will be the parent directory for the config file.
    XDG_CONFIG_HOME="${BATS_TMPDIR}/home"
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "config exists" {
    mkdir -p "${XDG_CONFIG_HOME}/home/.config/doily/"
    touch "${XDG_CONFIG_HOME}/home/.config/doily/doily.conf"
    check_config
}
