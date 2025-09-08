#!/bin/bash

[[ -d $HOME/.config/Code/Backups/ ]] ||
	echo "Backups dir not found"
	mkdir -p $HOME/.config/Code/Backups/
[[ -f /bin/code ]] || 
	echo "VSCode not found!"
[[ -f /bin/code ]] && # only exec if code is installed
	echo "backing up VSCode extensions"
	code --list-extensions | xargs -L 1 echo code --install-extension | tee $HOME/.config/Code/Backups/code_extensions.lst
