#!/bin/bash

source "./extras.sh"
source "./secrets.sh"

allDotfiles=(".enhancd" ".gitconfig" ".gvimrc" ".hgignore_global" ".iterm2" ".iterm2_shell_integration.zsh" ".kettle" ".npmrc" ".tmux.conf" ".tmux.conf.local" ".vimrc" ".zplug_plugins.zsh")
config_directory_filenames=("gh" "hub" "iterm2" "karabiner/karabiner.json" "starship.toml")

makeDirectoryIfNecessary() {
	DIRECTORY=$1
	if [[ ! -d "$DIRECTORY" ]]; then
		echo "No $DIRECTORY directory found. Creating it".
		mkdir -p "$DIRECTORY"
	fi
}

copyDotConfigFiles() {
	makeDirectoryIfNecessary "$PWD/.config"
	makeDirectoryIfNecessary "$PWD/.config/karabiner"

	config_dir="$HOME/.config"
	destination_dir="$PWD/.config"

	for i in "${!config_directory_filenames[@]}"; do
		filename=${config_directory_filenames[$i]}
		src_path="$config_dir/$filename"
		dest_path="$destination_dir/$filename"
		[[ -f "$src_path" ]] && cp -Rvf "$src_path" "$dest_path"
	done
}

initialCopy() {
	for i in "${!allDotfiles[@]}"; do
		dotfilename=${allDotfiles[$i]}
		original="$HOME/$dotfilename"
		directory="$(echo "$PWD")"
		destination="$directory/$dotfilename"
		if [[ -f "$original" || -d "$original" ]]; then
			echo "Copying $original"
			cp -Rvf "$original" ./
		else
			echo "No file found for '$original'. Skipping copy."
		fi
	done

	## copy public keys
	makeDirectoryIfNecessary "$PWD/.ssh"
	cp -Rvf "$HOME/.ssh/*.pub" "$PWD/.ssh/"
	cp -Rvf "$HOME/.ssh/*public.gpg" "$PWD/.ssh/"

	## make local directories if necessary
	cp -Rvf

}

replaceSimpleFiles() {
	mkdir ./backup
	for i in "${!allDotfiles[@]}"; do
		dotfilename=${allDotfiles[$i]}
		original="$HOME/$dotfilename"
		directory="$(echo "$PWD")"
		destination="$directory/$dotfilename"
		if [[ -f "$original" || -d "$original" ]]; then
			echo "File $original found"
			cp -Rvf "$original" ./backup/
			# rm -rfv "$original"
		else
			echo "No file found for '$original'. Skipping backup."
		fi

		# ln -s "$original" "$destination"
		echo "Made a link from $original pointing to $destination"
	done
}

do_prezto() {
	echo "Copy/installing prezto"
	echo "not yet implemented" && exit 1
}

do_config_dir() {
	echo "Copying config directory"
	mkdir -p "$HOME/.config/karabiner"
	for i in "${!config_directory_filenames[@]}"; do
		filename=$config_directory_filenames[$i]
		ln -s "$HOME/.config/$filename" "$PWD/.config/$filename"
	done
	echo "not yet implemented" && exit 1
}

do_aws() {
	echo "Configuring AWS CLI"
	mkdir "$HOME"/.aws
	if [[ -f "$HOME/.aws/config" ]]; then
		mkdir ./backup/.aws/
		cp -Rvf "$HOME/.aws/config" ./backup/.aws/config
	fi
	ln -s "$HOME"/.aws/config ./.aws/.config
	echo "not yet implemented" && exit 1
}

do_ssh() {
	echo "Copying SSH config and public keys"
	mkdir "$HOME/.ssh"
	mkdir ./backup/.ssh
	cp -Rv "$HOME/.ssh/config" ./backup/.ssh/config
	cp -Rv ./.ssh/
	rm -rfv "$HOME"/.ssh/config
	ln -s "$HOME"/.ssh/config "$PWD"/.ssh/config
	echo "not yet implemented" && exit 1
}

do_tmux() {
	echo "Configuring .tmux"
	TMUX_FILES=(".tmux.conf" ".tmux.conf.local")
	for i in "${!TMUX_FILES[@]}"; do
		file=${TMUX_FILES[$i]}
		[[ -f "$HOME/$file" ]] && cp -Rvf "$HOME/$file" "./backup/$file"
		ln -s "$HOME/$file" "$PWD/.tmux/$file"
		echo "Created a link from $HOME/$file to $PWD/.tmux/$file"
	done
	echo "Finished configuring tmux"
}

do_zplug() {
	echo "Creating a symlink to zplug"
	rm -rf ~/.zplug
	ln -s "$HOME"/.zplug "$PWD"/.zplug
	echo "Created a symlink from $HOME/.zplug -> $PWD/.zplug"
}

update_submodules() {
	git submodule update --recursive --init
	git submodule update --recursive --remote
	echo "Updated all submodules"
}

main() {
	echo "Running dotfiles installation"
	update_submodules
	replaceSimpleFiles &&
		do_prezto &&
		do_config_dir &&
		do_aws &&
		do_zplug &&
		do_tmux &&
		do_ssh &&
		install_extras &&
		decrypt_and_copy_secrets
	echo "Finished. Enjoy!"
}

main
