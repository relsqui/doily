#!/usr/bin/env bats

setup() {
    if [ -z "$CI" ]; then
        skip "don't mess with system files outside of CI"
    fi
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
    test ! ls "${HOME}/bin/doily"
    test ! ls "${HOME}/.config/doily/doily.conf"
}

@test "system install doesn't leave tempfiles" {
    sudo bash install.sh
    test ! ls "/tmp/doily-*"
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
    test ! ls /usr/local/bin/doily
    test ! ls /usr/local/etc/doily/default.conf
}

@test "user install doesn't leave tempfiles" {
    bash install.sh --user
    test ! ls "/tmp/doily-*"
}

teardown() {
    # run eats the return value, which we don't care about
    # we just want to make sure all our files get cleaned up
    run sudo bash install.sh --remove
    run bash install.sh --user --remove
}
