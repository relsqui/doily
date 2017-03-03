#!/usr/bin/env bats

assertFails() {
    run "$@"
    test "${status}" -ne 0
}

cleanup() {
    run sudo bash install.sh --remove
    run bash install.sh --user --remove
    run rm "${HOME}/.config/doily"
    run rm "${HOME}/.local/share/doily"
}

setup() {
    if [ -z "$CI" ]; then
        skip "don't mess with system files outside of CI"
    fi
    cleanup
}

@test "system file creation" {
    sudo bash install.sh
    ls /usr/local/bin/doily
    ls /usr/local/etc/doily/default.conf
}

@test "system install file perms" {
    skip "to see if this is the one holding up the build"
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

teardown() {
    cleanup
}
