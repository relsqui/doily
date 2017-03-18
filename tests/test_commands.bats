#!/usr/bin/env bats

load helpers

setup() {
    source "${BATS_TEST_DIRNAME}"/../doily
}

teardown() {
    rm -rf "${DOILY_TMP}"
}

@test "config command" {
    EDITOR=touch
    assertFails ls "${personal_config}"
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    command_config
    ls "${PERSONAL_CONFIG}"
}

@test "help command" {
    command_help
}

@test "read command" {
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    PAGER=touch
    for date in 1984-11-03 1985-12-05; do
        assertFails ls "${doily_dir}/${date}"
        command_read "${date}"
        ls "${doily_dir}/${date}"
    done

    assertFails test -s "${doily_dir}/1985-12-05"
    echo "echo 'hi' > \$1" > "${BATS_TMP_BIN}/doily_update"
    chmod +x "${BATS_TMP_BIN}/doily_update"
    PAGER=doily_update

    command_read last
    test "$(cat ${doily_dir}/1985-12-05)" == "hi"

    echo "echo 'bye' > \$1" > "${BATS_TMP_BIN}/doily_update"
    command_read
    test "$(cat ${doily_dir}/1985-12-05)" == "bye"
}

@test "default command is write" {
    EDITOR=touch
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    assertFails ls "${doily_dir}/$(date +%F)"
    run_command
    ls "${doily_dir}/$(date +%F)"
}

@test "nonexistant command" {
    assertFails run_command not_a_command
}
