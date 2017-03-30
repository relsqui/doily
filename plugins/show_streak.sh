################################################################################
# Doily plugin to show streak of daily writing.
# https://github.com/relsqui/doily
#
# (c) 2017 Finn Ellis.
# You are free to use, copy, modify, etc. this by the terms of the MIT license.
# See included LICENSE.txt for details.
#
# After writing, shows a series of . and o indicating how many days in a row
# you've written something (that is, days for which there's a dated file in
# your dailies directory).
################################################################################

PLUGIN_NAME="show_streak"
PLUGIN_AUTHOR="Finn Ellis <relsqui@chiliahedron.com>"
PLUGIN_VERSION="v0.1.0"
PLUGIN_DESCRIPTION="Daily writing streak tracker."
read -d ' ' PLUGIN_HELP <<EOF
After you write, show_streak will display a series of . and o characters, one
for each day since your earliest daily. An o represents a day you wrote, and
a . represents a day you didn't.
EOF
PROVIDES_PRE_WRITE=false
PROVIDES_POST_WRITE=true
PROVIDES_COMMANDS=

post_write() {
    total="$(ls "${DAILIES}" | wc -l)"
    if [[ "${total}" -eq 0 ]]; then
        # No dailies, so no streak.
        return
    fi

    dots=""
    count=0
    streak=0
    streak_broken=false
    first_filename="${DAILIES}/$(ls "${DAILIES}" | head -n 1)"
    seen_all=false
    while ! ${seen_all}; do
        daily_filename="${DAILIES}/$(date +%F --date="${count} days ago")"
        if [[ -e "${daily_filename}" ]]; then
            dots="o${dots}"
            if ! ${streak_broken}; then
                (( streak += 1 ))
            fi
        else
            dots=".${dots}"
            streak_broken=true
        fi
        if [[ "${daily_filename}" == "${first_filename}" ]]; then
            seen_all=true
        fi
        (( count += 1 ))
    done

    echo
    if [[ "${streak}" -eq 1 ]]; then
        if [[ "${total}" -gt "${streak}" ]]; then
            # Just came back after a gap.
            echo "Streak: ${dots} Welcome back!"
        else
            # First post!
            echo "Streak: ${dots} Welcome!"
        fi
    elif [[ "${streak}" -gt 1 ]]; then
        echo "Streak: ${dots} Nice."
    elif [[ "${count}" -gt 0 ]]; then
        echo "Streak: ${dots}"
    fi
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
