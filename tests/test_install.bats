#!/usr/bin/env bats

@test "system file creation" {
    sudo bash install.sh
    ls /usr/local/bin/doily
    test -x /usr/local/bin/doily
    ls /usr/local/etc/doily/default.conf
    test ! -x /usr/local/etc/doily/default.conf
}

@test "user file creation" {
    bash install.sh --user
    ls "${HOME}/bin/doily"
    test -x "${HOME}/bin/doily"
    ls "${HOME}/.config/doily/doily.conf"
    test ! -x "${HOME}/.config/doily/doily.conf"
}
