#!/usr/bin/env bats

load helpers

setup() {
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "config command" {
    EDITOR=touch
    assertFails ls "${personal_config}"
    mkdir -p "${XDG_CONFIG_HOME}/doily/doily.conf"
    command_config
    ls "${personal_config}"
}

@test "help command" {
    command_help
}
