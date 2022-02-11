#!/bin/bash

export allDotfiles=(".enhancd" ".gitconfig" ".gvimrc" ".hyper.js" ".hgignore_global" ".iterm2" ".iterm2_shell_integration.zsh" ".kettle" ".npmrc" ".tmux.conf" ".tmux.conf.local" ".vimrc" ".zplug_plugins.zsh")
export config_directory_filenames=("gh" "hub" "iterm2" "karabiner/karabiner.json" "starship.toml")
export secret_files=("id_rsa" "id_ed25519" "gpg lexstep secret.asc" "GPG rbutera secret.asc" "lexstep-development.pem" "lexstep-production.pem" "lexstep-staging.pem")

makeDirectoryIfNecessary() {
	DIRECTORY=$1
	if [[ ! -d "$DIRECTORY" ]]; then
		echo "No $DIRECTORY directory found. Creating it".
		mkdir -p "$DIRECTORY"
	fi
}
