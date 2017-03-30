################################################################################
# https://github.com/relsqui/doily
#
# (c) 2017 Finn Ellis
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
################################################################################

PLUGIN_NAME="use_git"
PLUGIN_AUTHOR="Finn Ellis <relsqui@chiliahedron.com>"
PLUGIN_VERSION="v0.1.0"
PLUGIN_DESCRIPTION="Saves your daily files in a git respository."
read -d ' ' PLUGIN_HELP <<EOF
After each time you close a daily file, commits all of your dailies into a git
repository with a generic message. The repository will be inside your
dailies directory.
EOF

# At which points should this plugin be activated?
PROVIDES_PRE_WRITE=false
PROVIDES_POST_WRITE=true

post_write() {
    # This will usually be excessive but harmless; if use_git is newly enabled,
    # though, it ensures the repo gets created and finds old dailies.
    git -C "${DAILIES}" init >/dev/null
    git -C "${DAILIES}" add "${DAILIES}" >/dev/null
    git -C "${DAILIES}" commit -m "Automatic commit from Doily."
}

main() {
    ############################################################################
    # DO NOT EDIT THIS. Edit the variables and functions above instead!
    #
    # Responds to requests from the Doily main script with either information
    # about the plugin or an action to be taken in response to a hook or a
    # command entered by the user.
    #
    # Globals:
    #    - CONF_FILE (exported by Doily)
    #    - PLUGIN_NAME
    #    - PROVIDES_PRE_WRITE
    #    - PROVIDES_POST_WRITE
    #    - PROVIDES_COMMANDS
    # Args:
    #    - The type of information requested by Doily. This can be either:
    #      . The name of a hook ("pre_write" or "post_write"), OR
    #      . The string "command" followed by a command name and arguments, OR
    #      . The string "provides" followed by either "pre_write",
    #        "post_write", or "commands".
    # Returns:
    #    - None.
    ############################################################################
    source "${CONF_FILE}"
    config="${XDG_CONFIG_HOME:-$HOME/.config}/doily/plugins/${PLUGIN_NAME}.conf"
    if [[ -e "${config}" ]]; then
        source "${config}"
    fi
    case "$1" in
        pre_write) pre_write ;;
        post_write) post_write ;;
        command) shift; custom_commands "$@" ;;
        provides)
            shift
            case "$1" in
                pre_write) $PROVIDES_PRE_WRITE && return 0 || return 1 ;;
                post_write) $PROVIDES_POST_WRITE && return 0 || return 1 ;;
                commands) echo "${PROVIDES_COMMANDS}" ;;
            esac
            ;;
    esac
}

main "$@"
