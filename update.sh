#!/bin/bash

DOTFILES_DIR="$HOME/dev/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup"

DOTFILES=(
	".bashrc $HOME/.bashrc"
	".tmux.conf $HOME/.tmux.conf"
	".gitconfig $HOME/.gitconfig"
	"nvim $HOME/.config/nvim"
	"ranger $HOME/.config/ranger"
)


supports_color() {
	[[ -t 1 && $(command -v tput) && $(tput colors) -ge 8 ]]
}

print_colored() {
	local color_code=$1
	local message=$2
	if supports_color; then
		echo -e "\033[${color_code}m${message}\033[0m"
	else
		echo "$message"
	fi
}

print_success() { print_colored "32" "$1"; }
print_error() { print_colored "91" "$1"; }
print_job() { print_colored "96" "$1"; }

cmd_copy() {
	local source=$1
	local target=$2

	if [ -d "$source" ]; then
		mkdir -p "$target/"
		print_job "CMD: cp -r $source/. $target/"
		cp -r "$source/". "$target/"
	else
		print_job "CMD: cp $source $target"
		cp "$source" "$target"
	fi
}

cmd_link() {
	local source=$1
	local target=$2

	print_job "CMD: ln -sf $source $target"
	if [ -e "$target" ]; then
		print_error "	$target already exists. skipping symlink creation."
	else
		ln -sf "$source" "$target"
	fi
}

cmd_move() {
	local source=$1
	local target=$2


	if [ -d "$source" ]; then
		mkdir -p "$target"  # Create the target directory if it doesn't exist
		print_job "CMD: mv $source $target/"
		mv "$source"/. "$target/"
	else
		print_job "CMD: mv $source $target"
		mv "$source" "$target"
	fi
}

link_dotfiles() {
	#print_job "pulling dotfiles"
	#git pull

	print_job "symlinking dotfiles"
	for file in "${DOTFILES[@]}"; do
		name=$(echo $file | cut -d ' ' -f 1)
		path=$(echo $file | cut -d ' ' -f 2)
		cmd_link $DOTFILES_DIR/$name $path
	done
	print_success "dotfiles fetched and symlinks created successfully."
}

copy_dotfiles() {
	print_job "copying dotfiles"
	for file in "${DOTFILES[@]}"; do
		name=$(echo $file | cut -d ' ' -f 1)
		path=$(echo $file | cut -d ' ' -f 2)
		cmd_copy $path $name
	done
	print_success "dotfiles copying successfully."
}

backup_current_dotfiles() {
	print_job "backing up current dotfiles by moving them to .backup/"
	for file in "${DOTFILES[@]}"; do
		name=$(echo $file | cut -d ' ' -f 1)
		path=$(echo $file | cut -d ' ' -f 2)
		cmd_move $path $BACKUP_DIR/$name
	done
	print_success "dotfiles moved to .backup/ successfully."
}

case $1 in
	setup-new-device)
		backup_current_dotfiles
		link_dotfiles
		;;
	backup)
		backup_current_dotfiles
		;;
	link)
		link_dotfiles
		;;
	copy)
		copy_dotfiles
		;;
	*)
		print_error "usage: $0 {setup-new-device|backup|link|copy}"
		exit 1
		;;
esac

