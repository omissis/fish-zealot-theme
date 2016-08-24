function fish_prompt
    set -l status_copy $status
    set -l status_color black 09f

    set -l root_glyph " ≡ "
    set -l root_color 222 fc3

    set -l cwd_root
    set -l cwd_base
    set -l branch_name

    switch "$PWD"
        case ~{,/\*}
        case \*
            set root_color ffc 09f
            set status_color $root_color[2] $root_color[1]
    end

    switch "$PWD"
        case / ~
        case \*
            set cwd_base (basename $PWD)
            set cwd_root (dirname $PWD | sed -nE "
                s|$HOME||
                s|/?([^/])[^/]*/?|\1 |gp
            ")
    end

    if set branch_name (git_branch_name)
        set -l git_color fff 09f
        set -l git_glyph 
        set -l git_right_glyph

        if git_is_detached_head
            set git_glyph ➦
        end

        if git_is_stashed
            set git_right_glyph "$git_right_glyph╍"
        end

        if git_is_touched
            set git_right_glyph ▪

            if git_is_staged
                set git_right_glyph +

                if git_is_dirty
                    set git_color 222 fc3
                    set git_right_glyph ▪+
                end

            else if git_is_dirty
                set git_color 222 fc3
                set git_right_glyph ▪
            end

        else if git_is_empty
            set git_color 222 fc3
        end

        if set -q git_right_glyph[1]
            set git_right_glyph $git_right_glyph ""
        end

        segment " $git_glyph $branch_name $git_right_glyph" $git_color
    end

    if test ! -z "$cwd_base"
        if test -z "$cwd_root"
            segment " $cwd_base " 222 ffc
        else
            segment " $cwd_base " 222 fc3
            segment " $cwd_root" 222 ffc
        end
    end

    if test 0 -eq (id -u $USER) -o ! -z "$SSH_CLIENT"
        segment " "(id -un | awk '

            /root/ {
                print
                exit
            } {
                print(substr($0, 1, 1)"…")
            }

        ')@(hostname)"  " ffc 333
    end

    if test "$status_copy" -ne 0
        segment " $status_copy " $root_color
        segment "" $status_color
    else
        segment $root_glyph $root_color
    end

    segment_close
end
