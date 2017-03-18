#!/usr/bin/env bats

################################################################################
# Tests for built-in Doily commands.
# https://github.com/relsqui/doily
#
# (c) 2017 Finn Ellis.
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
#
# This file is intended to be read by Bats.
################################################################################

load helpers

setup() {
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "config command" {
    # Test that the config command edits the config.
    EDITOR=touch
    assertFails ls "${personal_config}"
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    command_config
    ls "${PERSONAL_CONFIG}"
}

@test "help command" {
    # Test that the help command succeeds.
    command_help
}

@test "read command" {
    # Test read command argument parsing.
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    PAGER=touch
    for date in 1984-11-03 1985-12-05; do
        assertFails ls "${doily_dir}/${date}"
        command_read "${date}"
        ls "${doily_dir}/${date}"
    done

    export DOILY_TMP_BIN="${DOILY_TMP}/tmp_bin"
    mkdir -p "${DOILY_TMP_BIN}"
    export PATH="${DOILY_TMP_BIN}:${PATH}"

    assertFails test -s "${doily_dir}/1985-12-05"
    echo "echo 'hi' > \$1" > "${DOILY_TMP_BIN}/doily_update"
    chmod +x "${DOILY_TMP_BIN}/doily_update"
    PAGER=doily_update

    command_read last
    test "$(cat ${doily_dir}/1985-12-05)" == "hi"

    echo "echo 'bye' > \$1" > "${DOILY_TMP_BIN}/doily_update"
    command_read
    test "$(cat ${doily_dir}/1985-12-05)" == "bye"
}

@test "default command is write" {
    # Test that run_command chooses write when no command is specified.
    EDITOR=touch
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    assertFails ls "${doily_dir}/$(date +%F)"
    run_command
    ls "${doily_dir}/$(date +%F)"
}

@test "nonexistant command" {
    # Test that run_command fails when passed non-commands.
    assertFails run_command not_a_command
}
