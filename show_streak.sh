doily::get_streak() {
    total="$(ls "${doily_dir}" | wc -l)"
    if [[ "${total}" -eq 0 ]]; then
        # No dailies, so no streak.
        return
    fi

    dots=""
    count=0
    streak=0
    streak_broken=false
    first_filename="${doily_dir}/$(ls "${doily_dir}" | head -n 1)"
    seen_all=false
    while ! ${seen_all}; do
        daily_filename="${doily_dir}/$(date +%F --date="${count} days ago")"
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
