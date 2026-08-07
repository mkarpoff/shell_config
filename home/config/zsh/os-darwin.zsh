# macOS-specific zsh configuration (sourced from zshrc when uname == Darwin).

# BSD grep color flag (GNU uses --color=auto; see os-linux.zsh)
alias grep="grep -G"

# Workspace root on the Mac
export WORKSPACES_ROOT="/Volumes/workspace"

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Finch (Docker-compatible runtime)
export DOCKER_HOST=unix:///Applications/Finch/lima/data/finch/sock/finch.sock
export DOCKER_CONFIG=$HOME/.finch
export CDK_DOCKER=finch

# Spoken notifications via macOS `say`
notify() {
	say -v "Evan (Enhanced)" -r 180 "$*"
}
