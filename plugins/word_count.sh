################################################################################
# https://github.com/relsqui/doily
#
# (c) 2017 YOUR NAME HERE
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
################################################################################

# This should be the same as the filename of the plugin, minus the .sh part.
PLUGIN_NAME="word_count"
PLUGIN_AUTHOR="Finn Ellis <relsqui@chiliahedron.com>"
PLUGIN_VERSION="v0.1.0"
PLUGIN_DESCRIPTION="Counts words in all of your dailies."
read -d ' ' PLUGIN_HELP <<EOF
Use the \`doily wc\` command to print a listing of how many words are in your
daily files. They're listed chronologically; to see which days you wrote the
most on, pipe the output to sort, such as: \`doily wc | sort -n\`
EOF

# At which points should this plugin be activated?
PROVIDES_PRE_WRITE=false
PROVIDES_POST_WRITE=false
# What commands does this plugin enable?
PROVIDES_COMMANDS=( wc )

call_command() {
    # Maps custom commands to the functions they should run.
    # If you set PROVIDES_COMMANDS to ( ), you can delete this.
    comm="$1"
    shift
    case "${comm}" in
        # command) function_to_run "$@" ;;
        wc) count_words "$@" ;;
    esac
}

count_words() {
    # This function is run when you call `doily test1`.
    cd "${DAILIES}"
    wc -w *
    cd - >/dev/null
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
        call_command) shift; call_command "$@" ;;
        provides)
            shift
            case "$1" in
                pre_write) $PROVIDES_PRE_WRITE && return 0 || return 1 ;;
                post_write) $PROVIDES_POST_WRITE && return 0 || return 1 ;;
                # printf allows us to easily quote multi-word command names.
                commands) echo $(printf "'%s' " "${PROVIDES_COMMANDS[@]}") ;;
            esac
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
