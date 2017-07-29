#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
        --exclude "Gemfile.sh" \
        --exclude "Brewfile.sh" \
        --exclude "Caskfile.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude ".gitconfig-user" \
        --exclude ".idea" \
		-avh --no-perms . ~;

	if [ ! -e ~/.gitconfig-user ]; then
		cp .gitconfig-user ~
        echo "Please check ~/.gitconfig-user for correctness. You might not be @rahulsom"
	fi
	if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
		git clone https://github.com/bhilburn/powerlevel9k.git \
				~/.oh-my-zsh/custom/themes/powerlevel9k
	fi
	if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
		git clone git://github.com/zsh-users/zsh-autosuggestions \
				~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	fi

	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
