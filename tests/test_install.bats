#!/usr/bin/env bats

load helpers

setup() {
    mkdir -p "${HOME}"
    INSTALLER="${BATS_TEST_DIRNAME}/../install.sh"
}

@test "system file creation" {
    bash "${INSTALLER}"
    ls "${DOILY_TEST_BIN}/doily"
    ls "${DOILY_TEST_ETC}/doily/default.conf"
}

@test "system install file perms" {
    bash "${INSTALLER}"
    test -x "${DOILY_TEST_BIN}/doily"
    test ! -x "${DOILY_TEST_ETC}/doily/default.conf"
}

@test "system install doesn't install user files" {
    bash "${INSTALLER}"
    assertFails ls "${HOME}/bin/doily"
    assertFails ls "${HOME}/.config/doily/doily.conf"
}

@test "system install doesn't leave tempfiles" {
    bash "${INSTALLER}"
    assertFails ls "/tmp/doily-*"
}

@test "user install files exist" {
    bash "${INSTALLER}" --user
    ls "${HOME}/bin/doily"
    ls "${HOME}/.config/doily/doily.conf"
}

@test "user install file perms" {
    bash "${INSTALLER}" --user
    test -x "${HOME}/bin/doily"
    test ! -x "${HOME}/.config/doily/doily.conf"
}

@test "user install doesn't install system files" {
    bash "${INSTALLER}" --user
    assertFails ls "${DOILY_TEST_BIN}/doily"
    assertFails ls "${DOILY_TEST_ETC}/doily/default.conf"
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
    mkdir -p "${XDG_CONFIG_HOME}/doily"
    touch "${doily_dir}/foo"
    touch "${personal_config}"
    ls "${doily_dir}/foo"
    ls "${personal_config}"
    bash "${INSTALLER}" --remove
    ls "${doily_dir}/foo"
    ls "${personal_config}"
}

teardown() {
    (rm -f "${DOILY_TEST_BIN}/doily"
     rm -rf "${DOILY_TEST_ETC}/doily"
     rm -f "${HOME}/bin/doily"
     rm -rf "${HOME}/.config/doily"
     rm -rf "${HOME}/.local/share/doily") || true
}
