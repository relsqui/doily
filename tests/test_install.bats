#!/usr/bin/env bats

@test "system file creation" {
    sudo bash install.sh
    ls /usr/local/bin/doily
    ls /usr/local/etc/doily/default.conf
}
