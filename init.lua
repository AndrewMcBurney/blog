--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Current number stored for repeated keys
local number = 0

-- Null function
local null_func = function() end

-- Last function executed
local last_function = null_func

-- Boolean flag for hybrid mode
local hybrid_mode_enabled = false

-- Images for notifications
local vim_image = hs.image.imageFromPath("./hs-hybrid/images/vim.png")
local emacs_image = hs.image.imageFromPath("./hs-hybrid/images/emacs.png")
local hybrid_image = hs.image.imageFromPath("./hs-hybrid/images/hybrid.png")

-- Notification message informativeText
local vim_message = 'Vim-mode enabled. Enter \'insert-mode\' for emacs bindings'
local emacs_message = 'Emacs-mode enabled. \'esc\' to enable Vim-mode'
local hybrid_enable = 'Hybrid-mode enabled. \'command\' + \'esc\' to disable'
local hybrid_disable = 'Hybrid-mode disabled. \'command\' + \'esc\' to enable'

-- Includes
local mode   = require "hs-hybrid/includes/mode"
local move   = require "hs-hybrid/includes/move"
local delete = require "hs-hybrid/includes/delete"
local other  = require "hs-hybrid/includes/other"

-- Updates current number stored for repeated keys
local function set_number(num)
  number = number .. num
end

-- Execute a function 'number' amount of times
local function execute_function(func)
  -- Execute function at least once, and no more than 20 times
  for i = 0, math.max( 0, math.min( number - 1, 20 ) ), 1 do
    func()
  end

  last_function = func
  number = 0
end

-- Modes
local vim   = require "hs-hybrid/modes/vim"
local emacs = require "hs-hybrid/modes/emacs"

-- Enable or disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function() mode.enable_or_disable_hybrid() end)
