# Rahul's dotfiles

* Forked from [mathiasbynens](https://github.com/mathiasbynens/dotfiles).
* Uses oh-my-zsh

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/src/dotfiles`.)
The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/rahulsom/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
./bootstrap.sh
```

### Setup your `.gitconfig-user`

This file is written just once, and sets your name to `Rahul Somasunderam`
and email to `rahul.som@gmail.com`. In the unlikely event that this is
incorrect, please change this file.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here’s an example `~/.path` file that adds `~/utils` to the `$PATH`:

```bash
export PATH="$HOME/utils:$PATH"
```

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.osx
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae (after installing Homebrew, of course):

```bash
~/Brewfile.sh
```

### Install native apps with `brew cask`

You could also install native apps with [`brew cask`](https://github.com/phinze/homebrew-cask):

```bash
~/Caskfile.sh
```
