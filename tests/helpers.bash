assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}

teardown() {
    (sudo rm -f /usr/local/bin/doily
     sudo rm -rf /usr/local/etc/doily
     rm -f "${HOME}/bin/doily"
     rm -rf "${HOME}/.config/doily"
     rm -rf "${HOME}/.local/share/doily") || true
}
