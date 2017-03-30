################################################################################
# https://github.com/relsqui/doily
#
# (c) 2017 YOUR NAME HERE
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
################################################################################

# This should be the same as the filename of the plugin, minus the .sh part.
PLUGIN_NAME="my_plugin"
PLUGIN_AUTHOR="Namey McNamerson <me@example.com>"
PLUGIN_VERSION="v0.1.0"
PLUGIN_DESCRIPTION="One sentence about what it's for."
read -d ' ' PLUGIN_HELP <<EOF
A longer, more descriptive message that explains how to use the plugin or
what its output is, in an appropriate amount of detail. If the user needs to
know something the plugin, that something should be in here.
EOF

# At which points should this plugin be activated?
PROVIDES_PRE_WRITE=true
PROVIDES_POST_WRITE=true

pre_write() {
    # If you set PROVIDES_PRE_WRITE to false, you can delete this.
    echo "This will happen before someone writes in a daily file!"
}

post_write() {
    # If you set PROVIDES_POST_WRITE to false, you can delete this.
    echo "This will happen after someone writes in a daily file!"
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
