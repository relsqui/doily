#!/bin/bash

# Doily install script.
# (c) 2017 Finn Ellis, licensed under MIT.
# https://github.com/relsqui/doily

# Install a doily release from the Github repository, either systemwide
# or for the current user; or, remove doily for the system or user.
# Does not destroy user-specific configuration or data in any case.

VERSION="install_test"
BRANCH="install-script"

args=$(getopt -o urh -l user,remove,help -- $@) || exit 1
eval set -- "$args"

TARGET="system"
ACTION="install"
for arg; do
    case "$arg" in
        -u|--user) TARGET="user" ;;
        -r|--remove) ACTION="remove" ;;
        -h|--help)
            cat <<EOF
usage: bash install.sh [-h|--help] [-u|--user] [-r|--remove]

Install doily (http://github.com/relsqui/doily), a daily writing script.
With the -u or --user option, install for the current user. Otherwise, install
systemwide (which makes doily available to all users and requires root).
With the -r or --remove option, removes doily instead of installing it.
These options can be combined (use -ur to remove a userspace installation).
EOF
            exit 0
            ;;
        --) shift ;;
        *)
            echo "Unexpected argument: ${arg}. Use --help for help."
            exit 1
    esac
    shift
done

if [[ "${TARGET}" == "user" ]]; then
    binary_dir="$HOME/bin"
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/doily"
else
    binary_dir="/usr/local/bin"
    config_dir="/usr/local/etc/doily"
fi

if [[ "${ACTION}" == "remove" ]]; then
    rm -v "${binary_dir}/doily"
    if [[ "${TARGET}" == "system" ]]; then
        # Remove the systemwide default, but not user config.
        rm -vr "${config_dir}"
    fi
    echo "Add a note here about user data not being removed, and how to."
else
    tempdir="$(mktemp --tmpdir -dt doily-XXXXX)"
    #TODO: switch this to use https://github.com/relsqui/doily/archive/${VERSION}.tar.gz
    release_url="https://raw.githubusercontent.com/relsqui/doily/${BRANCH}/releases/doily-${VERSION}.tar.gz"
    curl "${release_url}" | tar -vxzC "${tempdir}"
    mkdir -vp "${binary_dir}" "${config_dir}"
    # Clobbering old binary with updated binary is OK.
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
