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
#
# This is also the test file for the new plugin system! Yay!
################################################################################

DOILY_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/doily/doily.conf"
PLUGIN_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/doily/plugins/show_streak.conf"
DAILIES="${XDG_DATA_HOME:-$HOME/.local/share}/doily/dailies"

custom_command() {
    # Not in use. Don't delete this!
    :
}

pre_write() {
    # Not in use. Don't delete this!
    :
}

post_write() {
    ############################################################################
    # Calculate the streak display and echo it.
    #
    # Globals:
    #    - DAILIES
    # Args:
    #    - None.
    # Returns:
    #    - None.
    ############################################################################
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
    # Parses arguments and calls the appropriate other function. Plugin authors
    # DO NOT NEED TO EDIT THIS, just edit the functions for whichever hooks
    # your plugin should respond to.
    #
    # Globals:
    #    - DOILY_CONF
    #    - PLUGIN_CONF
    # Config Vars:
    #    - DAILIES
    # Args:
    #    - The name of a hook ("pre_write" or "post_write"), or "command"
    #      followed by the command name and any arguments it requires.
    # Returns:
    #    - None.
    ############################################################################
    source "${DOILY_CONF}"
    if [[ -e "${PLUGIN_CONF}" ]]; then
        source "${PLUGIN_CONF}"
    fi
    case "$1" in
        pre_write)
            shift
            pre_write
            ;;
        post_write)
            shift
            post_write
            ;;
        command)
            shift
            custom_command "$@"
            ;;
    esac
}

main "$@"
