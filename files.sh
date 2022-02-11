#!/bin/bash

export allDotfiles=(".enhancd" ".gitconfig" ".gvimrc" ".hgignore_global" ".iterm2" ".iterm2_shell_integration.zsh" ".kettle" ".npmrc" ".tmux.conf" ".tmux.conf.local" ".vimrc" ".zplug_plugins.zsh")
export config_directory_filenames=("gh" "hub" "iterm2" "karabiner/karabiner.json" "starship.toml")

makeDirectoryIfNecessary() {
	DIRECTORY=$1
	if [[ ! -d "$DIRECTORY" ]]; then
		echo "No $DIRECTORY directory found. Creating it".
		mkdir -p "$DIRECTORY"
	fi
}
