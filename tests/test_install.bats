#!/usr/bin/env bats

if [ -z "$CI" ]; then
    echo "Testing the install script outside of CI is destructively unsafe."
    exit 0
fi

assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

@test "system file creation" {
    sudo bash install.sh
    ls /usr/local/bin/doily
    ls /usr/local/etc/doily/default.conf
}

@test "system install file perms" {
    sudo bash install.sh
    test -x /usr/local/bin/doily
    test ! -x /usr/local/etc/doily/default.conf
}

@test "system install doesn't install user files" {
    sudo bash install.sh
    assertFails ls "${HOME}/bin/doily"
    assertFails ls "${HOME}/.config/doily/doily.conf"
}

@test "system install doesn't leave tempfiles" {
    sudo bash install.sh
    assertFails ls "/tmp/doily-*"
}

@test "user install files exist" {
    bash install.sh --user
    ls "${HOME}/bin/doily"
    ls "${HOME}/.config/doily/doily.conf"
}

@test "user install file perms" {
    bash install.sh --user
    test -x "${HOME}/bin/doily"
    test ! -x "${HOME}/.config/doily/doily.conf"
}

@test "user install doesn't install system files" {
    bash install.sh --user
    assertFails ls /usr/local/bin/doily
    assertFails ls /usr/local/etc/doily/default.conf
}

@test "user install doesn't leave tempfiles" {
    bash install.sh --user
    assertFails ls "/tmp/doily-*"
}

@test "systemwide uninstall removes files" {
    sudo bash install.sh
    sudo bash install.sh --remove
    assertFails ls /usr/local/bin/doily
    assertFails ls /usr/local/etc/doily
}

@test "systemwide uninstall leaves user files" {
    sudo bash install.sh
    export EDITOR=touch
    doily
    ls "${HOME}/.local/share/doily/dailies/$(date +%F)"
    sudo bash install.sh --remove
    ls "${HOME}/.local/share/doily/dailies/$(date +%F)"
}

teardown() {
    (sudo rm -f /usr/local/bin/doily
     sudo rm -rf /usr/local/etc/doily
     rm -f "${HOME}/bin/doily"
     rm -rf "${HOME}/.config/doily"
     rm -rf "${HOME}/.local/share/doily") || true
}
