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

-- Notify the user what mode they're in
local function notify_user(title, text, image)
  hs.notify.new({title=title, informativeText=text}):setIdImage(image):send()
end

--------------------------------------------------------------------------------
-- Modal keybindings
--------------------------------------------------------------------------------

local emacs = hs.hotkey.modal.new()
local normal = hs.hotkey.modal.new()
local vim_delete = hs.hotkey.modal.new()

--------------------------------------------------------------------------------
-- Images for notifications
--------------------------------------------------------------------------------

local vim_image = hs.image.imageFromPath("./hs-hybrid/images/vim.png")
local emacs_image = hs.image.imageFromPath("./hs-hybrid/images/emacs.png")
local hybrid_image = hs.image.imageFromPath("./hs-hybrid/images/hybrid.png")

--------------------------------------------------------------------------------
-- Notification message informativeText
--------------------------------------------------------------------------------

local vim_message = 'Vim-mode enabled. Enter \'insert-mode\' for emacs bindings'
local emacs_message = 'Emacs-mode enabled. \'esc\' to enable Vim-mode'
local hybrid_enable = 'Hybrid-mode enabled. \'command\' + \'esc\' to disable'
local hybrid_disable = 'Hybrid-mode disabled. \'command\' + \'esc\' to enable'

--------------------------------------------------------------------------------
-- Includes
--------------------------------------------------------------------------------

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
  -- Execute function at least once, and no more than 20 times (interruptible)
  for i = 0, math.max( 0, math.min( number - 1, 20 ) ), 1 do
    func()
  end

  last_function = func
  number = 0
end

--------------------------------------------------------------------------------
-- Vim normal mode
--
-- @see: Keybindings for normal vim-mode. Bind these to nil so they don't have
-- an effect on the key listener
--------------------------------------------------------------------------------

-- Lowercase
normal:bind({}, 'a', function() vim_a() end)
normal:bind({}, 'b', function() execute_function( move.backward_word ) end)
normal:bind({}, 'd', function() mode.enter_delete_modal() end)
normal:bind({}, 'e', function() execute_function( move.forward_word ) end)
normal:bind({}, 'h', function() execute_function( move.left ) end)
normal:bind({}, 'i', function() vim_i() end)
normal:bind({}, 'j', function() execute_function( move.down ) end)
normal:bind({}, 'k', function() execute_function( move.up ) end)
normal:bind({}, 'l', function() execute_function( move.right ) end)
normal:bind({}, 'o', function() vim_o() end)
normal:bind({}, 'p', function() execute_function( paste ) end)
normal:bind({}, 'u', function() execute_function( undo ) end)
normal:bind({}, 'w', function() execute_function( move.forward_word ) end)
normal:bind({}, 'x', function() execute_function( delete.fndelete ) end)

-- Uppercase
normal:bind({"shift"}, 'a', function() vim_shift_a() end)
normal:bind({"shift"}, 'g', function() execute_function( vim_shift_g ) end)
normal:bind({"shift"}, 'i', function() vim_shift_i() end)
normal:bind({"shift"}, 'o', function() vim_shift_o() end)

-- Numbers
normal:bind({}, '0', function() set_number(0) end)
normal:bind({}, '1', function() set_number(1) end)
normal:bind({}, '2', function() set_number(2) end)
normal:bind({}, '3', function() set_number(3) end)
normal:bind({}, '4', function() set_number(4) end)
normal:bind({}, '5', function() set_number(5) end)
normal:bind({}, '6', function() set_number(6) end)
normal:bind({}, '7', function() set_number(7) end)
normal:bind({}, '8', function() set_number(8) end)
normal:bind({}, '9', function() set_number(9) end)

-- Symbols
normal:bind({"shift"}, '0', function() end)
normal:bind({"shift"}, '1', function() end)
normal:bind({"shift"}, '2', function() end)
normal:bind({"shift"}, '3', function() end)
normal:bind({"shift"}, '4', function() execute_function( move.forward_line ) end)
normal:bind({"shift"}, '5', function() end)
normal:bind({"shift"}, '6', function() execute_function( move.backward_line ) end)
normal:bind({"shift"}, '7', function() end)
normal:bind({"shift"}, '8', function() end)
normal:bind({"shift"}, '9', function() end)

-- Other
normal:bind({}, '.', function() execute_function( last_function ) end)
normal:bind({}, 'escape', function() number = 0 end)

--------------------------------------------------------------------------------
-- Vim delete mode
--
-- @see: Special modal mode for deletion related keybindings once 'd' key has
-- been pressed
--------------------------------------------------------------------------------

vim_delete:bind({}, 'b', function() execute_function( delete.vim.word_backward ) end)
vim_delete:bind({}, 'd', function() execute_function( delete.vim.line ) end)
vim_delete:bind({}, 'e', function() execute_function( delete.vim.word_forward ) end)
vim_delete:bind({}, 'w', function() execute_function( delete.vim.word_forward ) end)

vim_delete:bind({"shift"}, '4', function() execute_function( delete.vim.forward_line ) end)
vim_delete:bind({"shift"}, '6', function() execute_function( delete.vim.backward_line ) end)

--------------------------------------------------------------------------------
-- Emacs
--
-- @see: Mac already has a lot of emacs keybindings by default, which is why
-- this mode has less keybindings than the vim-mode
--------------------------------------------------------------------------------

-- Switch to vim normal mode
emacs:bind({}, 'escape', function() mode.enter_vim_normal() end)

-- Movement related bindings
emacs:bind({"alt"}, 'b', move.backward_word)
emacs:bind({"alt"}, 'f', move.forward_word)
emacs:bind({"alt", "shift"}, '[', move.forward_paragraph)
emacs:bind({"alt", "shift"}, ']', move.backward_paragraph)

-- Deletion related bindings
emacs:bind({"alt"}, 'delete', delete.word_forward)
emacs:bind({"alt"}, 'd', delete.word_backward)
