fgitlog() {
    log=$(git log --graph --color=always --format="%C(auto)%h%d %s %C(red)%C(bold)%an %C(black)%cr - %cD" "$@")
    if (( $? )) ; then
        return 1
    fi
    echo $log | fzf --prompt=" " --height 80% --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --bind "ctrl-m:execute:(grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF {} FZF-EOF"
}

# TODO can improve that with a bind to switch to what was installed
# fpac() {
#     pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
# }
#
# fyay() {
#     yay -Slq | fzf --multi --reverse --preview 'yay -Si {1}' | xargs -ro yay -S
# }

ftmux() {
    if [[ ! -n $TMUX ]]; then
        ID="`tmux list-sessions`"
        if [[ -z "$ID" ]]; then
            tmux new-session
        fi
        create_new_session="Create New Session"
        ID="$ID\n${create_new_session}:"
        ID="`echo $ID | fzf | cut -d: -f1`"
        if [[ "$ID" = "${create_new_session}" ]]; then
            tmux new-session
        elif [[ -n "$ID" ]]; then
            printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
            tmux attach-session -t "$ID"
        else
            :  # Start terminal normally
        fi
    fi
}

# --- Other ---

# List install files for dotfiles
# fdot() {
#     file=$(find "$DOTFILES/install" -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
#     [ -n "$file" ] && "$EDITOR" "$DOTFILES/install/$file"
# }

fman() {
    f=$(fd . $MANPATH/man${1:-1} -t f -x echo {/.} | fzf) && man $f
}

fpdf() {
    result=$(find -type f -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
    [ -n "$result" ] && zathura "$result" &
}

# fepub() {
#     result=$(find -type f -name '*.epub' | fzf --bind "ctrl-r:reload(find -type f -name '*.epub')")
#     [ -n "$result" ] && zathura "$result" &
# }

# fpop() {
#     # Only work with alias d defined as:
#     # alias d='dirs -v'
#     # for index ({1..9}) alias "$index"="cd +${index}"; unset index
#     d | fzf --height="20%" | cut -f 1 | source /dev/stdin
# }

# List projects
# fwork() {
#     result=$(find ~/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
#     [ -n "$result" ] && cd ~/workspace/$result
# }
