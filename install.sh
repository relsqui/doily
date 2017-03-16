#!/bin/bash

# Doily install script.
# (c) 2017 Finn Ellis, licensed under MIT.
# https://github.com/relsqui/doily

# Install a doily release from the Github repository, either systemwide
# or for the current user; or, remove doily for the system or user.
# Does not destroy user-specific configuration or data in any case.

set -e
trap 'error_out "$LINENO"' ERR

VERSION="0.1.0"
BRANCH="master"

target="system"
action="install"
binary_dir="/usr/local/bin"
config_dir="/usr/local/etc/doily"

error_out() {
    echo
    echo "The doily install script exited with an error on line ${1}."
    echo
    if [[ "${target}" == "system" && "${EUID}" != 0 ]]; then
        cat <<EOF
  ***   You seem to be attempting a systemwide operation without root.   ***
  ***              Did you mean to use sudo, or --user?                  ***
EOF
    else
        cat <<EOF
Check for error messages above. You can also use the --help option to get
more information about using the doily install script.
EOF
    fi
    cat <<EOF

If that doesn't help, you can open an issue by going to:

    https://github.com/relsqui/doily/issues

Use the search box to see if someone has already reported the same problem.
If not, click on the "new issue" button and explain what happened.
Please include ALL of the install script output in your description. Thanks!

EOF
    exit 2
}

install() {
    echo "Setting up temp directory."
    tempdir="$(mktemp --tmpdir -dt doily-XXXXX)"
    trap 'rm -r "${tempdir}"; echo "Removing temp directory."' EXIT
    echo "Fetching doily files and unpacking them."
    release_url="https://raw.githubusercontent.com/relsqui/doily/${BRANCH}/releases/doily-${VERSION}.tar.gz"
    curl -s "${release_url}" | tar -xzC "${tempdir}"
    echo "Creating directories."
    mkdir -p "${binary_dir}" "${config_dir}"
    # Clobbering old binary with updated binary is OK.
    echo "Moving binary into place."
    mv "${tempdir}/doily" "${binary_dir}"
    if [[ "${target}" == "user" ]]; then
        # Don't clobber existing user configuration with the default.
        echo "Creating a config file if it didn't already exist."
        mv -n "${tempdir}/default.conf" "${config_dir}/doily.conf"
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            cat <<EOF

Installed doily as $HOME/bin/doily. It looks like that directory
isn't in your \$PATH. If you want to be able to run doily without typing the
full path, you'll need to do something like:

echo 'export PATH="\$PATH:\$HOME/bin"' >> .bashrc && source .bashrc

EOF
        fi
    else
        # Check before clobbering the systemwide default.
        mv -i "${tempdir}/default.conf" "${config_dir}/default.conf"
    fi
    cat <<EOF

*** Success! Doily installed. ***

EOF
}

uninstall() {
    echo "Removing doily binary."
    rm "${binary_dir}/doily"
    if [[ "${target}" == "system" ]]; then
        # Remove the systemwide default, but not user config.
        echo "Removing default configuration. Leaving user data and config."
        rm -rf "${config_dir}"
    else
        cat <<EOF

Your personal settings and writings have been left alone.
If you really want to remove those, you can paste the following:

# Get rid of configuration, plugins, and so on:
rm -rf ${config_dir}
EOF
        # Try to find dailies directory, but don't error out if we fail.
        source "${config_dir}/doily.conf" 2>/dev/null || true
        if [[ -z "${doily_dir}" ]]; then
            cat <<EOF

Couldn't determine what your dailies directory is.
(Did you already delete your configuration file?)

EOF
        else
            cat <<EOF
# Get rid of your dailies. This can't be reversed!
rm -rf ${doily_dir}

EOF
        fi
    fi
}

main() {
    args=$(getopt -o urh -l user,remove,help -- "$@") || exit 1
    eval set -- "$args"

    for arg; do
        case "$arg" in
            -u|--user)
                target="user"
                binary_dir="$HOME/bin"
                # This complies with the XDG Base Directory Specification:
                # https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
                config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/doily"
                shift
                ;;
            -r|--remove)
                action="remove";
                shift
                ;;
            -h|--help)
                cat <<EOF
usage: bash install.sh [-h|--help] [-u|--user] [-r|--remove]

Install doily (http://github.com/relsqui/doily), a daily writing script.
Defaults to systemwide installation, which requires superuser privileges.

Options:
    -h --help   Display this help message.
    -u --user   Install for the current user only.
    -r --remove Remove doily rather than installing it.
                This can be combined with -u to remove a user install.
EOF
                exit 0
                ;;
            --) shift ;;
            *)
                echo "Unexpected argument: ${arg}. Use --help for help."
                exit 1
        esac
    done

    if [[ "${action}" == "remove" ]]; then
        uninstall
    else
        install
    fi
}

main $@
