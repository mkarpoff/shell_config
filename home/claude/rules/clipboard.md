# Clipboard

When asked to copy or send text to the clipboard, pipe it to `pbcopy` via shell. Example: `echo -n "text" | pbcopy`. On macOS this is native; on the dev-desktop `~/.local/bin/pbcopy` uses OSC 52 to forward to the local clipboard via tmux/iTerm2. When asked to read clipboard contents, use `pbpaste` (only works on macOS; on the remote side there is no read-back -- inform the user).
