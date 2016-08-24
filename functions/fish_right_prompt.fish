function fish_right_prompt
    set -l cmd_duration "$CMD_DURATION"

    if test "$cmd_duration" -gt 50
        set -l duration (echo $cmd_duration | humanize_time)

        if test "$cmd_duration" -gt 2000
            segment_right " $duration " 222 fc3
            segment_right "" black 09f
        else
            segment_right " $duration " 222 ffc
            segment_right "" black 09f
        end
    else if set -l last_job_id (jobs -l | awk '

        { c = $1 }

        END {
            if (c != "") {
                print c
            }
            exit !c
        }
    ')
        echo (set_color fc3)"%"(set_color ffc)$last_job_id(set_color fc3)" "(set_color normal)
    else
        segment_right " "(date "+%H:%M") 444 black
    end

    segment_close
end
