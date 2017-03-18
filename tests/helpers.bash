assertFails() {
    run "$@" >&2
    test "${status}" -ne 0
}
