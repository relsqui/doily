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
    fake_config="Default configuration."
    sudo mkdir -p "${DEFAULT_CONFIG_DIR}"
    sudo bash -c "echo \"${fake_config}\" > \"${DEFAULT_CONFIG}\""
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
    DAILIES=""
    assertFails check_storage
}

@test "relative storage location" {
    # Test that check_storage complains when the storage path is relative.
    DAILIES="relative/path"
    assertFails check_storage
}

@test "homedir storage location" {
    # Test that check_storage complains when the storage path is $HOME.
    DAILIES="${HOME}"
    assertFails check_storage
}

@test "create storage location" {
    # Test that check_storage creates the storage location if needed.
    DAILIES="${DOILY_TMP}/dailies"
    assertFails ls -d "${DAILIES}"
    check_storage
    ls -d "${DAILIES}"
}

@test "storage location is fine" {
    # Test that check_storage succeeds when all is well.
    DAILIES="${DOILY_TMP}/dailies"
    mkdir -p "${DAILIES}"
    check_storage
}
