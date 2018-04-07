#!/bin/bash
# Install command-line tools using Homebrew
# Usage: `brew bundle Brewfile`

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

brew install ack
brew install asciinema
brew install socat
brew install git
brew install git-lfs
brew install gnupg
brew install gnupg2
brew install go
brew install httpie
brew install hub
brew install ievms
brew install imagemagick --with-webp
brew install jq
brew install tree
brew install wget
brew install mas
brew install watch

brew install heroku-toolbelt

brew install nodenv
brew install rbenv
brew install ruby-build
brew install pyenv

brew tap neovim/neovim
brew install neovim
sudo gem install neovim
sudo pip3 install neovim
sudo easy_install pip
pip install --user neovim


brew cleanup
