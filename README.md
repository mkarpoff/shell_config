# bash_config
This contains all of my bash settings. 

## How it works
If for some reason you ended up here and for some reason you where wondering how this all works. All of these files are stored together and a symbolic link is created from the files in the git folder to the location they should be in the bash settings. This makes syncing very easy to do especially when you have multiple machines. It also makes setting up a new work environment very quick and easy to do. 

## How to install
Maybe I just forgot how this works or maybe someone else actually read this (still confused why you're here), so I'll include setup instructions

1. ``` git clone https://github.com/mkarpoff/bash_config ~/.bash_config``` you can actually put it anywhere but ```.bash_config``` is a good place
2. ``` cd ~/.bash_config```
3. ```./linkall.py``` If there are existing files you may want to link them before running this.

## Dependancy
I do use [powerline fonts](https://github.com/powerline/fonts) symbols in both my vim setup for [vim-airline](https://github.com/vim-airline/vim-airline) and for my bash_ps1.

I use [vim8-pack](https://github.com/mkarpoff/vim8-pack) (look at that, I wrote that one...) to manage my plugins. It makes updating the vim packages in [vim 8.0](https://github.com/vim/vim). On the note of vim 8.0 I have a build script in here for building vim 8.0 from source. It's called vim-build.

#Issues
God knows why you are here but if you post to the issues I check github pretty often... I have no life... :'(
