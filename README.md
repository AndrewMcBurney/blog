# hybrid
:shipit: System-wide hybrid emacs/vim keybindings for macOS.

## Status
This repo is currently a work in progress. Contributions are welcome!

## Motivation
The motivation behind this repo is that I get annoyed when I can't use vim or emacs keybindings in my daily computer use.
This lua script for hammerspoon was made to provide system-wide, vim and emacs keybindings akin to those offered in [spacemacs](http://spacemacs.org/).

`insert-mode` for vim has all of the emacs keybindings by default. Pressing `esc` in this mode will let you enter the modal `normal-mode` for vim.

## Usage
1. Download hammerspoon: http://www.hammerspoon.org/.
2. Clone this repo in your `~/.hammerspoon` directory.
3. Add `require "hybrid"` to your init.lua file.
4. Press `cmd` + `esc` to enter hybrid-mode when hammerspoon is running.
