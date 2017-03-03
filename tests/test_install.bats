#!/usr/bin/env bats

setup() {
    if [ -z "$CI" ]; then
        skip "don't mess with system files outside of CI"
    fi
    echo "starting test #${BATS_TEST_NUMBER} (${BATS_TEST_DESCRIPTION})"
}

@test "system install files exist" {
    sudo bash install.sh
    echo "installed"
    ls /usr/local/bin/doily
    echo "found binary"
    ls /usr/local/etc/doily/default.conf
    echo "found config"
}

@test "system install file perms" {
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
    echo "finished with test #${BATS_TEST_NUMBER} (${BATS_TEST_DESCRIPTION})"
}
