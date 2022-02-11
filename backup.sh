#!/bin/bash
source "./files.sh"

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
			echo "Copying '$original' to '$destination'"
			cp -Rvf "$original" "$destination"
		else
			echo "No file found for '$original'. Skipping copy."
		fi
	done

	## copy public keys
	makeDirectoryIfNecessary "$PWD/.ssh"
	cp -Rvf "$HOME/.ssh/*.pub" "$PWD/.ssh/"
	cp -Rvf "$HOME/.ssh/*public.gpg" "$PWD/.ssh/"

	## make local directories if necessary
	copyDotConfigFiles
	makeDirectoryIfNecessary "$PWD/.aws"
	cp -Rvf "$HOME/.aws/config" "$PWD/.aws/config"
}

backup_brew() {
	rm -rf ./Brewfile
	brew tap Homebrew/bundle
	brew bundle dump
}

backup_main() {
	initialCopy && backup_brew
	echo "Backup completed"
}
