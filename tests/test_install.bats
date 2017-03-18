#!/usr/bin/env bats

setup() {
    load helpers
    HOME="${DOILY_TMP}/home"
    mkdir -p "${HOME}"
    XDG_CONFIG_HOME="${HOME}/.config"
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
    skip "this needs reworking and I'm too tired to do it right now"
    bash "${INSTALLER}"
    export EDITOR=touch
    cat "${SAMPLE_CONF}" > "${global_config}"
    doily
    ls "${HOME}/.local/share/doily/dailies/$(date +%F)"
    bash "${INSTALLER}" --remove
    ls "${HOME}/.local/share/doily/dailies/$(date +%F)"
}

teardown() {
    (rm -f "${DOILY_TEST_BIN}/doily"
     rm -rf "${DOILY_TEST_ETC}/doily"
     rm -f "${HOME}/bin/doily"
     rm -rf "${HOME}/.config/doily"
     rm -rf "${HOME}/.local/share/doily") || true
}
