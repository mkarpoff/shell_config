# Linux zsh configuration (sourced from zshrc when uname == Linux).

# GNU coreutils color flags
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# NOTE: pbcopy is provided as a real script at ~/.local/bin/pbcopy (OSC 52 clipboard
# shim that forwards to the local clipboard over ssh/tmux). LANG is exported from
# ~/.zshenv so non-interactive ssh sessions get UTF-8 for tmux.
