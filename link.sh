#!/bin/zsh

for dot in ${HOME}/.dotfiles/.??*
do
    local t="$(basename $dot)"
    [[ "$t" == ".git" ]] && continue

    ln -snfv "${HOME}/.dotfiles/${t}" "${HOME}/${t}"
done
