#!/usr/bin/env bats

load helpers

setup() {
    INSTALLER="${BATS_TEST_DIRNAME}/../install.sh"
}

@test "system file creation" {
    bash "${INSTALLER}"
    ls "${DOILY_TEST_BIN}/doily"
    ls "${DEFAULT_CONFIG}"
}

@test "system install file perms" {
    bash "${INSTALLER}"
    test -x "${DOILY_TEST_BIN}/doily"
    test ! -x "${DEFAULT_CONFIG}"
}

@test "system install doesn't install user files" {
    bash "${INSTALLER}"
    assertFails ls "${HOME}/bin/doily"
    assertFails ls "${PERSONAL_CONFIG}"
}

@test "system install doesn't leave tempfiles" {
    bash "${INSTALLER}"
    assertFails ls "/tmp/doily-*"
}

@test "user install files exist" {
    bash "${INSTALLER}" --user
    ls "${HOME}/bin/doily"
    ls "${PERSONAL_CONFIG}"
}

@test "user install file perms" {
    bash "${INSTALLER}" --user
    test -x "${HOME}/bin/doily"
    test ! -x "${PERSONAL_CONFIG}"
}

@test "user install doesn't install system files" {
    bash "${INSTALLER}" --user
    assertFails ls "${DOILY_TEST_BIN}/doily"
    assertFails ls "${DEFAULT_CONFIG}"
}

@test "user install doesn't leave tempfiles" {
    bash "${INSTALLER}" --user
    assertFails ls "/tmp/doily-*"
}

@test "systemwide uninstall removes files" {
    bash "${INSTALLER}"
    bash "${INSTALLER}" --remove
    assertFails ls "${DOILY_TEST_BIN}/doily"
    assertFails ls "${DOILY_TEST_ETC}/doily"
}

@test "systemwide uninstall leaves user files" {
    bash "${INSTALLER}"
    doily_dir="${HOME}/.local/share/doily/dailies"
    mkdir -p "${doily_dir}"
    mkdir -p "${PERSONAL_CONFIG_DIR}"
    touch "${doily_dir}/foo"
    touch "${PERSONAL_CONFIG}"
    ls "${doily_dir}/foo"
    ls "${PERSONAL_CONFIG}"
    bash "${INSTALLER}" --remove
    ls "${doily_dir}/foo"
    ls "${PERSONAL_CONFIG}"
}

teardown() {
    (rm -f "${DOILY_TEST_BIN}/doily"
     rm -rf "${DEFAULT_CONFIG_DIR}"
     rm -f "${HOME}/bin/doily"
     rm -rf "${PERSONAL_CONFIG_DIR}"
     rm -rf "${HOME}/.local/share/doily") || true
}
