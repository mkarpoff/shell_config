# Dev-desktop (Amazon Linux) zsh configuration (sourced from zshrc when uname == Linux).

# GNU coreutils color flags
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# Workspace root on the Cloud Desktop
export WORKSPACES_ROOT="/ws"

# Personal AWS account + AAA workspace registration
export PERSONAL_ACCOUNT='760030034999'
alias register_with_aaa="/apollo/env/AAAWorkspaceSupport/bin/register_with_aaa.py"

# NOTE: pbcopy is provided as a real script at ~/.local/bin/pbcopy (OSC 52 clipboard
# shim that forwards to the local Mac clipboard over ssh/tmux). LANG is exported from
# ~/.zshenv so non-interactive ssh sessions get UTF-8 for tmux.
