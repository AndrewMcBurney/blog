--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- String representation of the last number pressed
local number_pressed = ""

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
  last_function = nil
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
end

local function move_left()
  hs.eventtap.keyStroke({}, "Left")
end

local function move_up()
  hs.eventtap.keyStroke({}, "Up")
end

local function move_down()
  hs.eventtap.keyStroke({}, "Down")
end

local function move_forward_word()
  hs.eventtap.keyStroke({"alt"}, "Right")
end

local function move_backward_word()
  hs.eventtap.keyStroke({"alt"}, "Left")
end

local function move_forward_line()
  hs.eventtap.keyStroke({"cmd"}, "Right")
end

local function move_backward_line()
  hs.eventtap.keyStroke({"cmd"}, "Left")
end

local function move_forward_paragraph()
  hs.eventtap.keyStroke({"alt"}, "Up")
end

local function move_backward_paragraph()
  hs.eventtap.keyStroke({"alt"}, "Down")
end

--------------------------------------------------------------------------------
-- Undo related functions
--------------------------------------------------------------------------------

local function undo()
  hs.eventtap.keyStroke({"cmd"}, "z")
end

--------------------------------------------------------------------------------
-- Deletion related functions
--------------------------------------------------------------------------------

local function delete()
  hs.eventtap.keyStroke({}, "delete")
end

local function fndelete()
  right()
  delete()
end

local function delete_word_forward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Right")
  hs.eventtap.keyStroke({}, "delete")
end

local function delete_word_backward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Left")
  hs.eventtap.keyStroke({}, "delete")
end

local function delete_line()
  move_backward_line()
  hs.eventtap.keyStroke({"ctrl"}, "k")
  delete()
end

--------------------------------------------------------------------------------
-- Paste functionality
--------------------------------------------------------------------------------

local function paste()
  hs.eventtap.keyStroke({"cmd"}, "v")
end

--------------------------------------------------------------------------------
-- Vim specific functions
--------------------------------------------------------------------------------

local function vim_a()
  enter_emacs()
  move_right()
end

local function vim_shift_a()
  enter_emacs()
  move_forward_line()
end

local function vim_shift_g()
  hs.eventtap.keyStroke({"cmd"}, "Down")
end

local function vim_i()
  enter_emacs()
end

local function vim_shift_i()
  enter_emacs()
  move_backward_line()
end

local function vim_o()
  move_forward_line()
  hs.eventtap.keyStroke({}, "Return")
end

local function vim_shift_o()
  print("implement me")
end

local function vim_delete_line()
  delete_line()
  enter_vim_normal()
end

local function vim_delete_word_backward()
  delete_word_backward()
  enter_vim_normal()
end

local function vim_delete_word_forward()
  delete_word_forward()
  enter_vim_normal()
end

local function delete_forward_line()
  hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
  delete()
  enter_vim_normal()
end

local function delete_backward_line()
  hs.eventtap.keyStroke({"cmd", "shift"}, "Left")
  delete()
  enter_vim_normal()
end

local function set_number(number)
  print(number)
  print("implement me")
end

-- Execute a function 'number' amount of times
local function execute_function(func)

  func()

  last_function = func
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

-- Lowercase
normal:bind({}, 'a', function() vim_a() end)
normal:bind({}, 'b', function() execute_function( move_backward_word ) end)
normal:bind({}, 'd', function() enter_delete_modal() end)
normal:bind({}, 'e', function() execute_function( move_forward_word ) end)
normal:bind({}, 'h', function() execute_function( move_left ) end)
normal:bind({}, 'i', function() vim_i() end)
normal:bind({}, 'j', function() execute_function( move_down ) end)
normal:bind({}, 'k', function() execute_function( move_up ) end)
normal:bind({}, 'l', function() execute_function( move_right ) end)
normal:bind({}, 'o', function() vim_o() end)
normal:bind({}, 'p', function() execute_function( paste ) end)
normal:bind({}, 'u', function() execute_function( undo ) end)
normal:bind({}, 'w', function() execute_function( move_forward_word ) end)
normal:bind({}, 'x', function() execute_function( fndelete ) end)

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

-- Symbols / Other
normal:bind({}, 'escape', function() end)
normal:bind({"shift"}, '4', function() execute_function( move_forward_line ) end)
normal:bind({"shift"}, '6', function() execute_function( move_backward_line ) end)

--------------------------------------------------------------------------------
-- Vim delete mode
--------------------------------------------------------------------------------

vim_delete:bind({}, 'b', function() execute_function( vim_delete_word_backward ) end)
vim_delete:bind({}, 'd', function() execute_function( vim_delete_line ) end)
vim_delete:bind({}, 'e', function() execute_function( vim_delete_word_forward ) end)
vim_delete:bind({}, 'w', function() execute_function( vim_delete_word_forward ) end)

vim_delete:bind({"shift"}, '4', function() execute_function( delete_forward_line ) end)
vim_delete:bind({"shift"}, '6', function() execute_function( delete_backward_line ) end)

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

emacs:bind({"alt"}, 'b', move_backward_word)

emacs:bind({"alt"}, 'f', move_forward_word)

emacs:bind({"alt", "shift"}, '[', move_forward_paragraph)

emacs:bind({"alt", "shift"}, ']', move_backward_paragraph)

--------------------------------------------------------------------------------
-- Deletion related bindings
--------------------------------------------------------------------------------

emacs:bind({"alt"}, 'delete', delete_word_forward)

emacs:bind({"alt"}, 'd', delete_word_backward)
