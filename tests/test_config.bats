#!/usr/bin/env bats

load helpers

setup() {
    source "${BATS_TEST_DIRNAME}"/../doily
}

teardown() {
    cat ~/test_output
    rm -rf "${BATS_TMPDIR}/doily"
}

@test "config exists" {
    mkdir -p "${XDG_CONFIG_HOME}/doily"
    touch "${personal_config}"
    check_config
}

@test "get default config" {
    mkdir -p "${DOILY_TEST_ETC}/doily"
    fake_config="Default configuration."
    echo "${fake_config}" > "${global_config}"
    assertFails test -s "${personal_config}"
    check_config
    test "$(cat ${personal_config})" == "${fake_config}"
}

@test "no default config" {
    assertFails check_config
}

@test "no storage location" {
    doily_dir=""
    assertFails check_storage
}

@test "relative storage location" {
    doily_dir="relative/path"
    assertFails check_storage
}

@test "homedir storage location" {
    echo $HOME
    doily_dir="${HOME}"
    assertFails check_storage 2>~/test_output
}

@test "create storage location" {
    doily_dir="${DOILY_TMP}/dailies"
    assertFails ls -d "${doily_dir}"
    check_storage
    ls -d "${doily_dir}"
}

@test "storage location is fine" {
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    check_storage
}