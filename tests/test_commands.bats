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

assertPerms() {
    test "$(stat -c %a "$1")" == "$2"
}

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
    # Test that the read command affects the correct files.
    PAGER=cat
    for date in 1984-11-03 1985-12-05; do
        echo "${date}" > "${doily_dir}/${date}"
        test "$(command_read "${date}")" == "${date}"
    done
    test "$(command_read)" == "1985-12-05"
    assertFails command_read "Some non-date."
}

@test "search command default" {
    # Test that the search command defaults to all daily files.
    for file in 1 2 3; do
        echo "foo" > "${doily_dir}/${file}"
        echo "${doily_dir}/${file}:foo" >> "${DOILY_TMP}/expected"
    done
    command_search "foo" > "${DOILY_TMP}/actual"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"

    echo "bar" > "${doily_dir}/4"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"
    echo "foo" >> "${doily_dir}/4"
    echo "${doily_dir}/4:foo" >> "${DOILY_TMP}/expected"
    command_search "foo" > "${DOILY_TMP}/actual"
    diff "${DOILY_TMP}/expected" "${DOILY_TMP}/actual"
}

@test "search command bad date" {
    assertFails command_search "foo" "not a date"
}

@test "search command specific dates" {
    echo "foo" > "${doily_dir}/1985-12-05"
    test "foo" == "$(command_search 'foo' 'December 5, 1985')"
    assertFails command_search 'foo' 'December 6, 1985'
    touch "${doily_dir}/1985-12-06"
    test "" == "$(command_search 'foo' 'December 6, 1985')"
}

@test "basic write command" {
    EDITOR=touch
    assertFails ls "${doily_dir}/$(date +%F)"
    command_write
    ls "${doily_dir}/$(date +%F)"
}

@test "write sets permissions" {
    EDITOR=touch

    command_write
    assertPerms "${doily_dir}" 700
    for file in $(ls "${doily_dir}"); do
        ls -l "${doily_dir}"
        assertPerms "${doily_dir}/${file}" 600
    done

    public_dailies=y
    command_write
    assertPerms "${doily_dir}" 755
    for file in $(ls "${doily_dir}"); do
        assertPerms "${doily_dir}/${file}" 644
    done

    public_dailies=
    doily_group=
    command_write
    assertPerms "${doily_dir}" 700
    for file in $(ls "${doily_dir}"); do
        assertPerms "${doily_dir}/${file}" 600
    done
}

@test "write group permissions" {
    # Group permissions are weird so they get their own test.
    groups | grep -qw doily_test || skip "can't do group test; not in group"
    EDITOR=touch
    public_dailies=
    doily_group=doily_test
    command_write
    assertPerms "${doily_dir}" 750
    for file in $(ls "${doily_dir}"); do
        assertPerms "${doily_dir}/${file}" 640
    done
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
