--------------------------------------------------------------------------------
-- Emacs
--
-- @see: Mac already has a lot of emacs keybindings by default, which is why
-- this mode has less keybindings than the vim-mode
--------------------------------------------------------------------------------

-- Includes
local delete = require "hs-hybrid/includes/delete"
local mode   = require "hs-hybrid/includes/mode"
local move   = require "hs-hybrid/includes/move"

-- Switch to vim normal mode
mode.emacs:bind({}, 'escape', function() mode.enter_vim_normal() end)

-- Movement related bindings
mode.emacs:bind({"alt"}, 'b', function() move.backward_word() end)
mode.emacs:bind({"alt"}, 'f', function() move.forward_word() end)
mode.emacs:bind({"alt", "shift"}, '[', function() move.forward_paragraph() end)
mode.emacs:bind({"alt", "shift"}, ']', function() move.backward_paragraph() end)

-- Deletion related bindings
mode.emacs:bind({"alt"}, 'delete', function() delete.word_forward() end)
mode.emacs:bind({"alt"}, 'd', function() delete.word_backward() end)
