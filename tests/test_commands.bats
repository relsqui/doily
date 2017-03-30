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

assertDailyPerms() {
    # Check that all the daily directory/file permissions are right.
    # Arguments: directory perms, file perms, group
    test "$(stat -c %a "${DAILIES}")" == "$1"
    test "$(stat -c %G "${DAILIES}")" == "$3"
    for file in $(ls "${DAILIES}"); do
        ls -l "${DAILIES}"
        test "$(stat -c %a "${DAILIES}/${file}")" == "$2"
        test "$(stat -c %G "${DAILIES}/${file}")" == "$3"
    done
}

setup() {
    mkdir -p "${DAILIES}"
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "identify dailyfile" {
    # Test various kinds of day input.
    touch "${DAILIES}/2017-01-01"
    touch "${DAILIES}/2017-01-02"
    test "$(identify_dailyfile last)" == "2017-01-02"
    touch "${DAILIES}/2017-01-03"
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
    # Test that the read command affects the correct files.
    PAGER=cat
    for date in 1984-11-03 1985-12-05; do
        echo "${date}" > "${DAILIES}/${date}"
        test "$(command_read "${date}")" == "${date}"
    done
    test "$(command_read)" == "1985-12-05"
    assertFails command_read "Some non-date."
}

@test "search command default" {
    # Test that the search command defaults to all daily files.
    for file in 1 2 3; do
        echo "foo" > "${DAILIES}/${file}"
        echo "${DAILIES}/${file}:foo" >> "${DOILY_TMP}/expected"
    done
    command_search "foo" > "${DOILY_TMP}/actual"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"

    echo "bar" > "${DAILIES}/4"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"
    echo "foo" >> "${DAILIES}/4"
    echo "${DAILIES}/4:foo" >> "${DOILY_TMP}/expected"
    command_search "foo" > "${DOILY_TMP}/actual"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"
}

@test "search command bad date" {
    assertFails command_search "foo" "not a date"
}

@test "search command specific dates" {
    echo "foo" > "${DAILIES}/1985-12-05"
    test "foo" == "$(command_search 'foo' 'December 5, 1985')"
    assertFails command_search 'foo' 'December 6, 1985'
    touch "${DAILIES}/1985-12-06"
    test "" == "$(command_search 'foo' 'December 6, 1985')"
}

@test "basic write command" {
    EDITOR=touch
    assertFails ls "${DAILIES}/$(date +%F)"
    command_write
    ls "${DAILIES}/$(date +%F)"
}

@test "write sets permissions" {
    EDITOR=touch

    command_write
    assertDailyPerms 700 600 "${USER}"

    public_dailies=y
    command_write
    assertDailyPerms 755 644 "${USER}"

    public_dailies=
    doily_group=
    command_write
    assertDailyPerms 700 600 "${USER}"
}

@test "write group permissions" {
    # Group permissions are weird so they get their own test.
    groups | grep -qw doily_test || skip "can't do group test; not in group"
    EDITOR=touch
    public_dailies=
    doily_group=doily_test
    command_write
    assertDailyPerms 750 640 "doily_test"
}

@test "permission setting precedence" {
    EDITOR=touch
    public_dailies=y
    doily_group=doily_test
    command_write
    assertDailyPerms 755 644 "${USER}"
}

@test "default command is write" {
    # Test that run_command chooses write when no command is specified.
    EDITOR=touch
    assertFails ls "${DAILIES}/$(date +%F)"
    run_command
    ls "${DAILIES}/$(date +%F)"
}

@test "nonexistant command" {
    # Test that run_command fails when passed non-commands.
    assertFails run_command not_a_command
}
