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
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "identify dailyfile" {
    # Test various kinds of day input.
    touch "${doily_dir}/2017-01-01"
    touch "${doily_dir}/2017-01-02"
    test "$(identify_dailyfile last)" == "2017-01-02"
    touch "${doily_dir}/2017-01-03"
    test "$(identify_dailyfile last)" == "2017-01-03"
    test "$(identify_dailyfile "2017-01-01")" == "2017-01-01"
    test "$(identify_dailyfile "January 2, 2017")" == "2017-01-02"
    test "$(identify_dailyfile "")" == ""
    test "$(identify_dailyfile "1985-12-05")" == ""
    test "$(identify_dailyfile "This isn't a parseable date.")" == ""
}

@test "config command" {
    # Test that the config command edits the config.
    EDITOR=touch
    assertFails ls "${personal_config}"
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    command_config
    ls "${PERSONAL_CONFIG}"
}

@test "version command" {
    # Test that the version command succeeds.
    command_version
}

@test "help command" {
    # Test that the help command succeeds.
    command_help
}

@test "read command" {
    # Test read command argument parsing.
    PAGER=cat
    for date in 1984-11-03 1985-12-05; do
        echo "${date}" > "${doily_dir}/${date}"
        test "$(command_read "${date}")" == "${date}"
    done
    test "$(command_read)" == "1985-12-05"
    assertFails command_read "Some non-date."
}

@test "default command is write" {
    # Test that run_command chooses write when no command is specified.
    EDITOR=touch
    assertFails ls "${doily_dir}/$(date +%F)"
    run_command
    ls "${doily_dir}/$(date +%F)"
}

@test "nonexistant command" {
    # Test that run_command fails when passed non-commands.
    assertFails run_command not_a_command
}
