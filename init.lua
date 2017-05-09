--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Last function executed
local last_function = nil

-- Boolean flag for hybrid mode
local hybrid_mode_enabled = false

-- Notify the user what mode they're in
local function notify_user(title, text, image)
  hs.notify.new({title=title, informativeText=text}):setIdImage(image):send()
end

--------------------------------------------------------------------------------
-- Modal keybindings
--------------------------------------------------------------------------------

local emacs  = hs.hotkey.modal.new()

local normal = hs.hotkey.modal.new()
local vim_delete = hs.hotkey.modal.new()

--------------------------------------------------------------------------------
-- Images for notifications
--------------------------------------------------------------------------------

local vim_image    = hs.image.imageFromPath("./hs-hybrid/images/vim.png")
local emacs_image  = hs.image.imageFromPath("./hs-hybrid/images/emacs.png")
local hybrid_image = hs.image.imageFromPath("./hs-hybrid/images/hybrid.png")

--------------------------------------------------------------------------------
-- Notification message informativeText
--------------------------------------------------------------------------------

local vim_message = 'Vim-mode enabled. Enter \'insert-mode\' for emacs bindings'
local emacs_message  = 'Emacs-mode enabled. \'esc\' to enable Vim-mode'
local hybrid_enable  = 'Hybrid-mode enabled. \'command\' + \'esc\' to disable'
local hybrid_disable = 'Hybrid-mode disabled. \'command\' + \'esc\' to enable'

--------------------------------------------------------------------------------
-- Change Mode Functions
--
-- @see: Functions to change mode and notify user of the changes
--------------------------------------------------------------------------------

-- Enter vim normal mode
function enter_vim_normal()
  emacs:exit()
  vim_delete:exit()
  normal:enter()
  notify_user('Vim', vim_message, vim_image)
end

-- Enter vim delete mode
function enter_delete_modal()
  normal:exit()
  vim_delete:enter()
end

-- Enter emacs / vim insert mode
function enter_emacs()
  normal:exit()
  vim_delete:exit()
  emacs:enter()
  notify_user('Emacs', emacs_message, emacs_image)
end

-- Enable / Disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function()
  if hybrid_mode_enabled then
    hybrid_mode_enabled = false
    normal:exit()
    vim_delete:exit()
    emacs:exit()
    notify_user('Hybrid-mode Disabled', hybrid_disable, hybrid_image)
  else
    hybrid_mode_enabled = true
    emacs:enter()
    notify_user('Hybrid-mode Enabled', hybrid_enable, hybrid_image)
  end
end)

--------------------------------------------------------------------------------
-- Binding Functions
--
-- @see: Functions for binding to modal key modes
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Movement related functions
--------------------------------------------------------------------------------

local function move_right()
  hs.eventtap.keyStroke({}, "Right")
  last_function = move_right
end

local function move_left()
  hs.eventtap.keyStroke({}, "Left")
  last_function = move_left
end

local function move_up()
  hs.eventtap.keyStroke({}, "Up")
  last_function = move_up
end

local function move_down()
  hs.eventtap.keyStroke({}, "Down")
  last_function = move_down
end

local function move_forward_word()
  hs.eventtap.keyStroke({"alt"}, "Right")
  last_function = move_forward_word
end

local function move_backward_word()
  hs.eventtap.keyStroke({"alt"}, "Left")
  last_function = move_backward_word
end

local function move_forward_line()
  hs.eventtap.keyStroke({"cmd"}, "Right")
  last_function = move_forward_line
end

local function move_backward_line()
  hs.eventtap.keyStroke({"cmd"}, "Left")
  last_function = move_backward_line
end

local function move_forward_paragraph()
  hs.eventtap.keyStroke({"alt"}, "Up")
  last_function = move_forward_paragraph
end

local function move_backward_paragraph()
  hs.eventtap.keyStroke({"alt"}, "Down")
  last_function = move_backward_paragraph
end

--------------------------------------------------------------------------------
-- Undo related functions
--------------------------------------------------------------------------------

local function undo()
  hs.eventtap.keyStroke({"cmd"}, "z")
  last_function = undo
end

--------------------------------------------------------------------------------
-- Deletion related functions
--------------------------------------------------------------------------------

local function delete()
  hs.eventtap.keyStroke({}, "delete")
  last_function = delete
end

local function fndelete()
  right()
  delete()
  last_function = fndelete
end

local function delete_word_forward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Right")
  hs.eventtap.keyStroke({}, "delete")
  last_function = delete_word_forward
end

local function delete_word_backward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Left")
  hs.eventtap.keyStroke({}, "delete")
  last_function = delete_word_backward
end

local function delete_line()
  move_backward_line()
  hs.eventtap.keyStroke({"ctrl"}, "k")
  delete()
  last_function = delete_line
end

--------------------------------------------------------------------------------
-- Paste functionality
--------------------------------------------------------------------------------

local function paste()
  hs.eventtap.keyStroke({"cmd"}, "v")
  last_function = paste
end

--------------------------------------------------------------------------------
-- Vim specific functions
--------------------------------------------------------------------------------

local function vim_a()
  enter_emacs()
  move_right()
  last_function = nil
end

local function vim_shift_a()
  enter_emacs()
  move_forward_line()
  last_function = nil
end

local function vim_i()
  enter_emacs()
  last_function = nil
end

local function vim_shift_i()
  enter_emacs()
  move_backward_line()
  last_function = nil
end

local function vim_o()
  move_forward_line()
  hs.eventtap.keyStroke({}, "Return")
  last_function = nil
end

local function vim_shift_o()
  print("implement me")
  last_function = nil
end

local function vim_delete_line()
  delete_line()
  enter_vim_normal()
  last_function = vim_delete_line
end

local function vim_delete_word_backward()
  delete_word_backward()
  enter_vim_normal()
  last_function = vim_delete_word_backward
end

local function vim_delete_word_forward()
  delete_word_forward()
  enter_vim_normal()
  last_function = vim_delete_word_forward
end

local function delete_forward_line()
  hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
  delete()
  enter_vim_normal()
  last_function = delete_forward_line
end

local function delete_backward_line()
  hs.eventtap.keyStroke({"cmd", "shift"}, "Left")
  delete()
  enter_vim_normal()
  last_function = delete_backward_line
end

local function invoke_last_command()
  last_function()
end

local function number()
  print("implement me")
end

--------------------------------------------------------------------------------
-- Vim
--
-- @see: Keybindings for normal vim-mode. Bind these to nil so they don't have
-- an effect on the key listener
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Vim normal mode
--------------------------------------------------------------------------------

-- Basic
normal:bind({}, 'a', vim_a, nil)
normal:bind({"shift"}, 'a', vim_shift_a, nil)
normal:bind({}, 'b', move_backward_word, nil)
normal:bind({}, 'd', enter_delete_modal, nil)
normal:bind({}, 'e', move_forward_word, nil)
normal:bind({}, 'h', move_left, nil)
normal:bind({}, 'i', vim_i, nil)
normal:bind({"shift"}, 'i', vim_shift_i, nil)
normal:bind({}, 'j', move_down, nil)
normal:bind({}, 'k', move_up, nil)
normal:bind({}, 'l', move_right, nil)
normal:bind({}, 'o', vim_o, nil)
normal:bind({"shift"}, 'o', vim_shift_o, nil)
normal:bind({}, 'p', paste, nil)
normal:bind({}, 'u', undo, nil)
normal:bind({}, 'w', move_forward_word, nil)
normal:bind({}, 'x', fndelete, nil)

-- Numbers
normal:bind({}, '0', number, nil)
normal:bind({}, '1', number, nil)
normal:bind({}, '2', number, nil)
normal:bind({}, '3', number, nil)
normal:bind({}, '4', number, nil)
normal:bind({}, '5', number, nil)
normal:bind({}, '6', number, nil)
normal:bind({}, '7', number, nil)
normal:bind({}, '8', number, nil)
normal:bind({}, '9', number, nil)

-- Symbols / Other
normal:bind({}, '.', invoke_last_command, nil)
normal:bind({"shift"}, '4', move_forward_line, nil, move_forward_line)   -- $
normal:bind({"shift"}, '6', move_backward_line, nil, move_backward_line) -- ^
normal:bind({}, 'escape', function() end)

--------------------------------------------------------------------------------
-- Vim delete mode
--------------------------------------------------------------------------------

vim_delete:bind({}, 'b', vim_delete_word_backward, nil)
vim_delete:bind({}, 'd', vim_delete_line, nil)
vim_delete:bind({}, 'e', vim_delete_word_forward, nil)
vim_delete:bind({}, 'w', vim_delete_word_forward, nil)
vim_delete:bind({"shift"}, '4', delete_forward_line, nil, delete_forward_line)
vim_delete:bind({"shift"}, '6', delete_backward_line, nil, delete_backward_line)

--------------------------------------------------------------------------------
-- Emacs
--
-- @see: Mac already has a lot of emacs keybindings by default, which is why
-- this mode has less keybindings than the vim-mode
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Switch to vim normal mode
--------------------------------------------------------------------------------

emacs:bind({}, 'escape', function() enter_vim_normal() end)

--------------------------------------------------------------------------------
-- Movement related bindings
--------------------------------------------------------------------------------

emacs:bind({"alt"}, 'b', move_backward_word, nil, move_backward_word)

emacs:bind({"alt"}, 'f', move_forward_word, nil, move_forward_word)

emacs:bind({"alt", "shift"}, '[', move_forward_paragraph, nil,
  move_forward_paragraph)

emacs:bind({"alt", "shift"}, ']', move_backward_paragraph, nil,
  move_backward_paragraph)

--------------------------------------------------------------------------------
-- Deletion related bindings
--------------------------------------------------------------------------------

emacs:bind({"alt"}, 'delete', delete_word_forward, nil, delete_word_forward)

emacs:bind({"alt"}, 'd', delete_word_backward, nil, delete_word_backward)
