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
    # Test that check_config finds a personal config file.
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    touch "${PERSONAL_CONFIG}"
    check_config
}

@test "get default config" {
    # Test that check_config gets the default config when needed.
    mkdir -p "${DEFAULT_CONFIG_DIR}"
    fake_config="Default configuration."
    echo "${fake_config}" > "${DEFAULT_CONFIG}"
    assertFails test -s "${PERSONAL_CONFIG}"
    check_config
    test "$(cat ${PERSONAL_CONFIG})" == "${fake_config}"
}

@test "no default config" {
    # Test that check_config fails when no default config is available.
    assertFails check_config
}

@test "no storage location" {
    # Test that check_storage fails when no storage location is set.
    doily_dir=""
    assertFails check_storage
}

@test "relative storage location" {
    # Test that check_storage complains when the storage path is relative.
    doily_dir="relative/path"
    assertFails check_storage
}

@test "homedir storage location" {
    # Test that check_storage complains when the storage path is $HOME.
    doily_dir="${HOME}"
    assertFails check_storage
}

@test "create storage location" {
    # Test that check_storage creates the storage location if needed.
    doily_dir="${DOILY_TMP}/dailies"
    assertFails ls -d "${doily_dir}"
    check_storage
    ls -d "${doily_dir}"
}

@test "storage location is fine" {
    # Test that check_storage succeeds when all is well.
    doily_dir="${DOILY_TMP}/dailies"
    mkdir -p "${doily_dir}"
    check_storage
}
