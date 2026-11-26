# bash_config
This contains all of my bash settings. 

## How it works
If for some reason you ended up here and for some reason you where wondering how this all works. All of these files are stored together and a symbolic link is created from the files in the git folder to the location they should be in the bash settings. This makes syncing very easy to do especially when you have multiple machines. It also makes setting up a new work environment very quick and easy to do. 

## How to install
Maybe I just forgot how this works or maybe someone else actually read this (still confused why you're here), so I'll include setup instructions

1. ``` git clone https://github.com/mkarpoff/bash_config ~/.bash_config``` you can actually put it anywhere but ```.bash_config``` is a good place
2. ``` cd ~/.bash_config```
3. ```./linkall.py``` If there are existing files you may want to link them before running this.

## Private overlay
Anything machine- or employer-specific lives in a separate private repo that layers on top of this one:

1. Put the overlay repo's git URL in `~/.config/shell_config.private-remote` (one line; not committed anywhere).
2. Run `./sync` (also linked as `shell-config-sync`). It pulls this repo, clones or pulls the overlay into `~/.config/shell_config-private`, and links both `files.json` manifests.

The overlay plugs into these hook points:

| Hook | Used for |
|---|---|
| `~/.config/zsh/env.d/*.zsh` | sourced by `zshenv` (all shells, incl. non-interactive ssh) |
| `~/.config/zsh/conf.d/*.zsh` | sourced at the end of `zshrc`, after `compinit` |
| `ps1_segment_functions` | zsh array of function names; each prints an extra leading prompt segment |
| `~/.tmux/local.conf` | sourced after the OS-specific tmux fragment |
| `SSH_TMUX_REMOTE_BIN` | remote tmux binary used by `ssh-tmux` |

`linkall.py --manifest <files.json> --yes` links any manifest; `--yes` replaces dangling or mis-pointed symlinks (never regular files).

## Dependancy
I do use [powerline fonts](https://github.com/powerline/fonts) symbols in both my vim setup for [vim-airline](https://github.com/vim-airline/vim-airline) and for my bash_ps1.

I have a build script in here for building [vim 8.0](https://github.com/vim/vim) from source. It's called vim-build.

#Issues
God knows why you are here but if you post to the issues I check github pretty often... I have no life... :'(
