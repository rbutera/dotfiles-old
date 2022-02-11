#!/bin/bash
source "./files.sh"
source "./extras.sh"
source "./secrets.sh"

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
	zsh_files=(".zprezto" ".zprezto-contrib" ".zshenv")
	zsh_rc_files=("zshrc" "zpreztorc")
	for i in "${!zsh_files[@]}"; do
		file=${zsh_files[$i]}
		echo "Removing original $file"
		rm -rf "$HOME/$file"
		ln -s "$HOME/$file" "$PWD/$file"
		echo "Made a link from $HOME/$file -> $PWD/$file"
	done

	for i in "${!zsh_rc_files[@]}"; do
		file=${zsh_rc_files[$i]}
		echo "Removing original $file"
		rm -rf "$HOME/.$file"
		ln -s "$HOME/.$file" "$PWD/.zprezto/runcoms/$file"
		echo "Made a link from $HOME/.$file -> $PWD/$file"
	done

}

do_config_dir() {
	echo "Copying config directory"
	mkdir -p "$HOME/.config/karabiner"
	for i in "${!config_directory_filenames[@]}"; do
		filename=$config_directory_filenames[$i]
		ln -s "$HOME/.config/$filename" "$PWD/.config/$filename"
	done
}

do_aws() {
	echo "Configuring AWS CLI"
	mkdir "$HOME"/.aws
	if [[ -f "$HOME/.aws/config" ]]; then
		mkdir ./backup/.aws/
		cp -Rvf "$HOME/.aws/config" ./backup/.aws/config
	fi
	rm -rf "$HOME/.aws/config"
	ln -s "$HOME/.aws/config" ./.aws/.config
}

do_ssh() {
	echo "Copying SSH config and public keys"
	mkdir "$HOME/.ssh"
	mkdir ./backup/.ssh
	cp -Rv "$HOME/.ssh/config" ./backup/.ssh/config
	rm -rf "$HOME/.ssh/config"
	ln -s "$HOME/.ssh/config" "$PWD/.ssh/config"
	rm -rfv "$HOME"/.ssh/config
	ln -s "$HOME"/.ssh/config "$PWD"/.ssh/config
	rsync --av --exclude='config' --exclude="$HOME/.ssh/config" "$PWD/.ssh/" "$HOME/.ssh/"
	echo "SSH info copied"
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
