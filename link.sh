#!/bin/zsh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

for dot in ${SCRIPT_DIR}/.??*
do
    local target="$(basename $dot)"
    [[ "$target" == ".git" ]] && continue
    [[ -d $dot ]] && continue

    ln -snfv "${SCRIPT_DIR}/${target}" "${HOME}/${target}"
done
