#!/usr/bin/env bats

################################################################################
# Tests for Doily configuration verification.
# https://github.com/relsqui/doily
#
# (c) 2017 Finn Ellis.
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
#
# This file is designed to be read by Bats.
################################################################################

load helpers

setup() {
    source "${BATS_TEST_DIRNAME}"/../doily
}

@test "config exists" {
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    touch "${PERSONAL_CONFIG}"
    check_config
}

@test "get default config" {
    mkdir -p "${DEFAULT_CONFIG_DIR}"
    fake_config="Default configuration."
    echo "${fake_config}" > "${DEFAULT_CONFIG}"
    assertFails test -s "${PERSONAL_CONFIG}"
    check_config
    test "$(cat ${PERSONAL_CONFIG})" == "${fake_config}"
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
    doily_dir="${HOME}"
    assertFails check_storage
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
