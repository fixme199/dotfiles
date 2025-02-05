#!/bin/zsh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

# pacman -S vim openssh zsh git tig tmux

# plugins #
# zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# vim-plugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

zsh ${SCRIPT_DIR}/link.sh
