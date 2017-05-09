--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Table storing session vim history
local vim_history = ""

-- Empty function definition to eat up modal keypress in vim
local function nothing() end

-- Declare functions above definition
-- Boolean flag for hybrid mode
local hybrid_mode_enabled = false

-- Modal keybindings
local emacs  = hs.hotkey.modal.new()
local normal = hs.hotkey.modal.new()

-- Notify the user what mode they're in
local function notify_user(title, text, image)
  hs.notify.new({title=title, informativeText=text}):setIdImage(image):send()
end

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
  normal:enter()
  notify_user('Vim', vim_message, vim_image)
end

-- Enter emacs / vim insert mode
function enter_emacs()
  normal:exit()
  vim_history = ""
  emacs:enter()
  notify_user('Emacs', emacs_message, emacs_image)
end

-- Enable / Disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function()
  if hybrid_mode_enabled then
    hybrid_mode_enabled = false
    vim_history = ""
    normal:exit()
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

--------------------------------------------------------------------------------
-- Vim
--
-- @see: Keybindings for normal vim-mode. Bind these to nil so they don't have
-- an effect on the key listener
--------------------------------------------------------------------------------

normal:bind({}, '.', nothing, nil)

normal:bind({}, 'a', vim_a, nil)
normal:bind({"shift"}, 'a', vim_shift_a, nil)
normal:bind({}, 'b', move_backward_word, nil)
normal:bind({}, 'd', nothing, nil)
normal:bind({}, 'e', move_forward_word, nil)
normal:bind({}, 'h', move_left, nil)
normal:bind({}, 'i', vim_i, nil)
normal:bind({"shift"}, 'i', vim_shift_i, nil)
normal:bind({}, 'j', move_down, nil)
normal:bind({}, 'k', move_up, nil)
normal:bind({}, 'l', move_right, nil)
normal:bind({}, 'o', vim_o, nil)
normal:bind({"shift"}, 'o', nothing, nil)
normal:bind({}, 'p', paste, nil)
normal:bind({}, 'u', undo, nil)
normal:bind({}, 'w', move_forward_word, nil)
normal:bind({}, 'x', fndelete, nil)

normal:bind({"shift"}, '4', move_forward_line, nil, move_forward_line)   -- $
normal:bind({"shift"}, '6', move_backward_line, nil, move_backward_line) -- ^
normal:bind({}, 'escape', function() vim_history = "" end)

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
