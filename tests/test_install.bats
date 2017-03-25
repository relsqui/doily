#!/usr/bin/env bats

################################################################################
# Tests for the Doily install script.
# https://github.com/relsqui/doily
#
# (c) 2017 Finn Ellis.
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
#
# This file is designed to be read by Bats.
################################################################################

load helpers

cisudo() {
    # Skip tests that require sudo, since they aren't prompting for auth.
    # I'm not sure why that doesn't work here; it does elsewhere. :/
    if [ -z "$CI" ]; then
        skip "skipping sudo test outside of CI"
    else
        sudo "$@"
    fi
}

setup() {
    INSTALLER="${BATS_TEST_DIRNAME}/../install.sh"
}

@test "system file creation" {
    # Test that the installer creates system files for systemwide install.
    cisudo bash "${INSTALLER}"
    ls "${DOILY_TEST_BIN}/doily"
    ls "${DEFAULT_CONFIG}"
}

@test "system install file perms" {
    # Test that the systemwide binary is executable and the config is not.
    cisudo bash "${INSTALLER}"
    test -x "${DOILY_TEST_BIN}/doily"
    test ! -x "${DEFAULT_CONFIG}"
}

@test "system install doesn't install user files" {
    # Test that the systemwide install doesn't create files in userspace.
    cisudo bash "${INSTALLER}"
    assertFails ls "${HOME}/bin/doily"
    assertFails ls "${PERSONAL_CONFIG}"
}

@test "system install doesn't leave tempfiles" {
    # Test that the systemwide install cleans up its tempfiles.
    cisudo bash "${INSTALLER}"
    assertFails ls -d "/tmp/doily-*"
}

@test "user install files exist" {
    # Test that userspace install creates the appropriate files.
    bash "${INSTALLER}" --user
    ls "${HOME}/bin/doily"
    ls "${PERSONAL_CONFIG}"
}

@test "user install file perms" {
    # Test that the userspace binary is executable and the config is not.
    bash "${INSTALLER}" --user
    test -x "${HOME}/bin/doily"
    test ! -x "${PERSONAL_CONFIG}"
}

@test "user install doesn't install system files" {
    # Test that userspace install doesn't create system files.
    bash "${INSTALLER}" --user
    assertFails ls "${DOILY_TEST_BIN}/doily"
    assertFails ls "${DEFAULT_CONFIG}"
}

@test "user install doesn't leave tempfiles" {
    # Test that userspace install cleans up its tempfiles.
    bash "${INSTALLER}" --user
    assertFails ls -d "/tmp/doily-*"
}

@test "systemwide uninstall removes files" {
    # Test that systemwide uninstall removes the install locations.
    cisudo bash "${INSTALLER}"
    cisudo bash "${INSTALLER}" --remove
    assertFails ls "${DOILY_TEST_BIN}/doily"
    assertFails ls "${DOILY_TEST_ETC}/doily"
}

@test "systemwide uninstall leaves user files" {
    # Test that systemwide uninstall doesn't remove userspace files.
    cisudo bash "${INSTALLER}"
    doily_dir="${HOME}/.local/share/doily/dailies"
    mkdir -p "${doily_dir}"
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    touch "${doily_dir}/foo"
    touch "${PERSONAL_CONFIG}"
    ls "${doily_dir}/foo"
    ls "${PERSONAL_CONFIG}"
    cisudo bash "${INSTALLER}" --remove
    ls "${doily_dir}/foo"
    ls "${PERSONAL_CONFIG}"
}

@test "systemwide install without root fails and cleans up" {
    # Test that attempting systemwide install as non-root cleans up neatly.
    run bash "${INSTALLER}"
    test "${status}" -ne 0
    assertFails ls -d "/tmp/doily-*"
}
