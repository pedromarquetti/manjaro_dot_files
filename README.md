# Welcome to my Manjaro Dotfiles!

This is a collection of my basic config files for my _Manjaro_ env, created with a
bare git repo that auto-tracks my files (idea from
[here](https://www.atlassian.com/git/tutorials/dotfiles))

[My Pop OS 22.04 dotfiles](https://github.com/pedromarquetti/pop_dot_files) 

I'll always be adding more stuff

## Contents:

1. setup.sh _(work in proggress)_ with automated installation.
2. .zshrc with my preferred aliases.
3. .config with vscode config/settings/snippets and dconf settings
4. .backup containing crontab-install-scripts and UBlockOrigin backup file

## Setup

### For an automated setup just run:

```
curl -L https://raw.githubusercontent.com/pedromarquetti/manjaro_dot_files/master/.local/bin/setup.sh | bash
```

### For non-root users (you have to run the above first)

```
curl -L https://raw.githubusercontent.com/pedromarquetti/manjaro_dot_files/master/.local/bin/setup_noroot.sh | bash
```

### Gnome Extensions

in `~/.local/bin/install_gnome_ext.sh` there are some basic scripts that set up
gnome ext.

### Setup NVIM

```
curl -L https://raw.githubusercontent.com/pedromarquetti/manjaro_dot_files/master/.local/bin/setup_nvim.sh | bash
```

### Or you could do it manually

```
git clone https://github.com/pedromarquetti/manjaro_dot_files.git
# mv cfg_files/<file/dir> ~
```

### Test on Docker container

At `.docker/images/test`, run
`cd .docker/images/test && docker build --no-cache -t root_scripttest/dotfiles .`

Then `docker run -it root_scripttest/dotfiles`

In there, you can safely run /setup.sh and setup_noroot.sh

## Scripts

Some useful script are located at `.local/bin`, they can be used to save your
configs locally, my_cron_install and root_cron_install are useful crontabs I use
to keep my system up to date

## Backups

At `.backup` and `.config/Code/Backups/`, there are some configs I use. The
scripts mentioned above will update these configs

## Extensions

Some extensions I like:

1. [Dash2DockLite](https://github.com/icedman/dash2dock-lite) to make my Dock
   prettier (can also be installed from
   [here](https://extensions.gnome.org/extension/4994/dash2dock-lite/))
1. [Search Light](https://github.com/icedman/search-light) cool looking search
   bar (can also be installed from
   [here](https://extensions.gnome.org/extension/5489/search-light/))

## Issues

Please report if you find any issues, I just learned Shell Scripting, so, errors
are expected
