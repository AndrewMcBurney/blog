--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Includes
local mode   = require "hs-hybrid/includes/mode"

-- Modes
local vim    = require "hs-hybrid/modes/vim"
local emacs  = require "hs-hybrid/modes/emacs"

-- Enable or disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function() mode.toggle_hybrid_mode() end)
