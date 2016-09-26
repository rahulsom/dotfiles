#!/bin/bash
# Install command-line tools using Homebrew
# Usage: `brew bundle Brewfile`

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

brew install ack
brew install git
brew install imagemagick --with-webp
brew install hub
brew install wget
brew install tree
brew install httpie

brew install heroku-toolbelt

brew install nodenv
brew install rbenv
brew install ruby-build
brew install pyenv

brew cleanup
