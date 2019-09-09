# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

COLOR_BLACK="%{$fg_no_bold[black]%}"
COLOR_DARKGRAY="%{$fg_bold[black]%}"
COLOR_PINK="%{$fg_no_bold[red]%}"
COLOR_RED="%{$fg_bold[red]%}"
COLOR_CYAN="%{$fg_no_bold[cyan]%}"
COLOR_AQUA="%{$fg_bold[cyan]%}"
COLOR_LIMEGREEN="%{$fg_no_bold[green]%}"
COLOR_GREEN="%{$fg_bold[green]%}"
COLOR_ANIS="%{$fg_no_bold[yellow]%}"
COLOR_ORANGE="%{$fg_bold[yellow]%}"
COLOR_LIGHTBLUE="%{$fg_no_bold[blue]%}"
COLOR_BLUE="%{$fg_bold[blue]%}"
COLOR_PURPLE="%{$fg_no_bold[magenta]%}"
COLOR_MAGENTA="%{$fg_bold[magenta]%}"
COLOR_WHITE="%{$fg_no_bold[white]%}"
COLOR_LIGHTGRAY="%{$fg_bold[white]%}"
COLOR_RESET="%{$reset_color%}"

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{blue}`basename $VIRTUAL_ENV`%f') '
}
PR_GIT_UPDATE=1

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="(${COLOR_CYAN}%b%u%c${COLOR_RESET})"
FMT_ACTION="(${COLOR_LIMEGREEN}%a${COLOR_RESET})"
FMT_UNSTAGED="${COLOR_ORANGE}!"
FMT_STAGED="${COLOR_LIMEGREEN}*"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_preexec {
    case "$2" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *hub*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
    PR_GIT_UPDATE=1
}
add-zsh-hook chpwd steeef_chpwd

function steeef_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if git ls-files --other --exclude-standard 2> /dev/null | grep -q "."; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="(${COLOR_CYAN}%b%u%c${COLOR_PINK}?${COLOR_RESET})"
        else
            FMT_BRANCH="(${COLOR_CYAN}%b%u%c${COLOR_RESET})"
        fi
        zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"

        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd steeef_precmd

function echo_upper_line {
    # current(vcs_info) ---------- ... ---------- user@hostname
    local invisible='%([BSUbfksu]|([FK]|){*})'

    local left="${COLOR_BLUE}%~${COLOR_RESET} $vcs_info_msg_0_$(virtualenv_info)"
    local right="${COLOR_LIGHTBLUE}%n${COLOR_RESET}@${COLOR_ORANGE}%m${COLOR_RESET} "

    local left_length=${#${(S%%)left//$~invisible/}}
    local right_length=${#${(S%%)right//$~invisible/}}
    local padding=$(($COLUMNS - ($left_length + $right_length + 3)))
    echo "$left ${COLOR_DARKGRAY}${(r:$padding::-:)}${COLOR_RESET} $right"
}

PROMPT=$'
$(echo_upper_line)
%# '
