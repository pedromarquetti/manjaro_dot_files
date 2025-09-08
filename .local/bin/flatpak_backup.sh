#!/bin/bash

[[ -d $HOME/.backup  ]] ||
	mkdir $HOME/.backup
echo "creating list of installed flatpak apps"
flatpak list --columns=application --app | awk '{print "flatpak install  --user \""$0"\" "}' |tee $HOME/.backup/flatpak_backup.lst
