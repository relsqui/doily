#!/bin/bash

# Doily install script.
# (c) 2017 Finn Ellis, licensed under MIT.
# https://github.com/relsqui/doily

# Install a doily release from the Github repository, either systemwide
# or for the current user; or, uninstall doily for the system or user.
# Does not destroy user-specific configuration or data in any case.

# Everything here except VERSION is just for development and testing.
VERSION="install_test"
BRANCH="install-script"
TARGET="user"
ACTION="install"

if [[ "${TARGET}" == "user" ]]; then
    binary_dir="$HOME/bin"
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/doily"
else
    binary_dir="/usr/local/bin"
    config_dir="/usr/local/etc/doily"
fi

if [[ "${ACTION}" == "uninstall" ]]; then
    rm -v "${binary_dir}/doily"
    rm -vr "${config_dir}"
    echo "Add a note here about user data not being removed, and how to."
else
    tempdir="$(mktemp --tmpdir -dt doily-XXXXX)"
    #TODO: switch this to use https://github.com/relsqui/doily/archive/${VERSION}.tar.gz, which will also require changing the tar command
    release_url="https://raw.githubusercontent.com/relsqui/doily/${BRANCH}/releases/doily-${VERSION}.tar"
    curl "${release_url}" | tar -vxC "${tempdir}"
    mkdir -vp "${binary_dir}" "${config_dir}"
    mv -v "${tempdir}/doily" "${binary_dir}"
    if [[ "${TARGET}" == "user" ]]; then
        # Don't clobber existing user configuration with the default.
        mv -vn "${tempdir}/default.conf" "${config_dir}/doily.conf"
        echo "Add a note here about editing your path."
    else
        # Check before clobbering the systemwide default.
        mv -vi "${tempdir}/default.conf" "${config_dir}/default.conf"
    fi
    rm -vr "${tempdir}"
fi
