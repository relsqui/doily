#!/bin/bash

VERSION="install_test"

tarball="doily-${VERSION}.tar"
release_url="https://raw.githubusercontent.com/relsqui/doily/master/releases/${tarball}"
old_pwd="${PWD}"

fetch_release() {
    # Retrieve the release tarball into a temp directory and cd to it.
    tempdir="$(mktemp --tmpdir -dt doily-XXXXX)"
    echo "curl -N \"${release_url}\""
    curl -N "${release_url}" | tar -xvC "${tempdir}"
    ls "${tempdir}"
}

systemwide_install() {
    # Create the appropriate target directories and move install files.
    mkdir -pv /usr/local/bin/
    mkdir -pv /usr/local/lib/doily/plugins
    mkdir -pv /usr/local/etc/doily/plugins
    mv -v doily /usr/local/bin
    mv -v default.conf /usr/local/etc/doily
}

cleanup() {
    cd "${old_pwd}"
    rmdir "${tempdir}"
}

main() {
    fetch_release
}

main
