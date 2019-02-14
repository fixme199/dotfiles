##### zsh #####
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
autoload -Uz colors && colors

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt auto_cd
setopt auto_list
setopt auto_menu
setopt globdots
setopt hist_ignore_dups
setopt share_history

unsetopt list_types

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

##### source #####

##### export #####
export DOTFILES="$HOME/.dotfiles"

##### alias #####
alias ls='ls --color=auto'
alias ll='ls -lphA --group-directories-first --time-style=long-iso'

##### bindkey #####
bindkey "^[[H"    beginning-of-line   # Home
bindkey "^[[F"    end-of-line         # End
bindkey "^[[3~"   delete-char         # Delete
bindkey "^[[1;5D" emacs-backward-word # Ctrl + Left
bindkey "^[[1;5C" emacs-forward-word  # Ctrl + Right
bindkey "^_"      backward-kill-word  # Ctrl + Backspace

##### nvm #####
case ${OSTYPE} in
    linux*)
        source /usr/share/nvm/init-nvm.sh
        ;;
    msys*)
        export NVM_HOME="$HOME/.nvm"
        export NVM_SYMLINK="$NVM_HOME/node"
        export PATH="$PATH:$NVM_HOME:$NVM_SYMLINK"
        ;;
esac

##### zplug #####
source "${HOME}/.zplug/init.zsh"

# theme
zplug "${DOTFILES}/.zsh/themes", from:local, as:theme, use:"steeef-mod.zsh-theme"
# plugin
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

# check install
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load
zplug load --verbose
