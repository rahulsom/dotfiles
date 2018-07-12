#!/usr/bin/env bash

# Make vim the default editor.
set -x -g EDITOR 'nvim';

# Enable persistent REPL history for `node`.
set -x -g NODE_REPL_HISTORY ~/.node_history;
# Allow 32³ entries; the default is 1000.
set -x -g NODE_REPL_HISTORY_SIZE '32768';
# Use sloppy mode by default, matching web browsers.
set -x -g NODE_REPL_MODE 'sloppy';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
set -x -g PYTHONIOENCODING 'UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
set -x -g HISTSIZE '32768';
set -x -g HISTFILESIZE "$HISTSIZE";
# Omit duplicates and commands that begin with a space from history.
set -x -g HISTCONTROL 'ignoreboth';

# Prefer US English and use UTF-8.
set -x -g LANG 'en_US.UTF-8';
set -x -g LC_ALL 'en_US.UTF-8';

# Highlight section titles in manual pages.
set -x -g LESS_TERMCAP_md "$yellow";

# Don’t clear the screen after quitting a manual page
set -x -g MANPAGER "less -X";

# Link Homebrew casks in `/Applications` rather than `~/Applications`
set -x -g HOMEBREW_CASK_OPTS "--appdir /Applications";

# Set a reasonable home for go libraries and tools
set -x -g GOPATH $HOME/go

# Capture the IP address for local connections
# set -x -g IP (ifconfig en0 | grep inet | awk '$1  "inet" {print $2}')
