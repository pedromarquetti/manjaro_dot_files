#!/bin/bash

(date && \
echo 'Flatpak update' && \
flatpak -y update) >> $HOME/.local/logs/flatpak/autoupdate.log