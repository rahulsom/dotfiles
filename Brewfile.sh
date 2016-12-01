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
brew install httpie
brew install httpstat
brew install hub
brew install imagemagick --with-webp
brew install tree
brew install wget
brew install mas

brew install heroku-toolbelt

brew install nodenv
brew install rbenv
brew install ruby-build
brew install pyenv


brew cleanup
