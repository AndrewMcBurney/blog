--------------------------------------------------------------------------------
-- hybrid.lua
--
-- System-wide Vim and Emacs keybindings for Mac
-- @author Andrew McBurney
--------------------------------------------------------------------------------

-- Boolean flag for hybrid mode
local hybrid_mode_enabled = false

-- Images for notifications
local disable_image = hs.image.imageFromPath("./images/off.png")
local enable_image  = hs.image.imageFromPath("./images/on.png")
local emacs_image   = hs.image.imageFromPath("./images/emacs.png")
local vim_image     = hs.image.imageFromPath("./images/vim.png")

-- Modal keybindings
local emacs = hs.hotkey.modal.new()
local normal = hs.hotkey.modal.new()

-- Notify the user what mode they're in
local function notify_user(title, text, image)
  hs.notify.new({title=title, informativeText=text, contentImage=image}):send()
end

-- Enable / Disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function()
  if hybrid_mode_enabled then
    hybrid_mode_enabled = false
    emacs:exit()
    normal:exit()
    notify_user(
      'Hybrid',
      'Hybrid-mode disabled. \'command\' + \'esc\' to re-enable',
      disable_image
    )
  else
    hybrid_mode_enabled = true
    emacs:enter()
    notify_user(
      'Hybrid',
      'Hybrid-mode enabled. \'command\' + \'esc\' to disable',
      enable_image
    )
  end
end)

-- Movement related functions
local function left()     hs.eventtap.keyStroke({}, "Left") end
local function right()    hs.eventtap.keyStroke({}, "Right") end
local function up()       hs.eventtap.keyStroke({}, "Up") end
local function down()     hs.eventtap.keyStroke({}, "Down") end
local function back()     hs.eventtap.keyStroke({"alt"}, "Left") end
local function forward()  hs.eventtap.keyStroke({"alt"}, "Right") end

-- Deletion related functions
local function delete_word_forward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Right")
  hs.eventtap.keyStroke({}, "delete")
end

local function delete_word_backward()
  hs.eventtap.keyStroke({"alt", "shift"}, "Left")
  hs.eventtap.keyStroke({}, "delete")
end

local function delete_line()
  hs.eventtap.keyStroke({"cmd"}, "Left")
  hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
  hs.eventtap.keyStroke({}, "delete")
end

local function delete()
  hs.eventtap.keyStroke({}, "delete")
end

local function fndelete()
  hs.eventtap.keyStroke({}, "Right")
  hs.eventtap.keyStroke({}, "delete")
end

--------------------------------------------------------------------------------
-- Vim
--
-- Keybindnigs for normal vim-mode
--------------------------------------------------------------------------------

-- Movement related bindings
normal:bind({}, 'h', left, nil, left)
normal:bind({}, 'l', right, nil, right)
normal:bind({}, 'k', up, nil, up)
normal:bind({}, 'j', down, nil, down)
normal:bind({}, 'b', back, nil, back)
normal:bind({}, 'w', forward, nil, forward)
normal:bind({}, 'e', forward, nil, forward)

-- Deletion related bindings
normal:bind({}, 'd', delete, nil, delete)
normal:bind({}, 'x', fndelete, nil, fndelete)

-- Enter insert mode
normal:bind({}, 'i', function()
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({"shift"}, 'i', function()
  hs.eventtap.keyStroke({"cmd"}, "Left")
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({}, 'a', function()
  hs.eventtap.keyStroke({}, "Right")
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({"shift"}, 'a', function()
  hs.eventtap.keyStroke({"cmd"}, "Right")
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({}, 'o', nil, function()
  hs.eventtap.keyStroke({"cmd"}, "Right")
  normal:exit()
  emacs:enter()
  hs.eventtap.keyStroke({}, "Return")
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({"shift"}, 'o', nil, function()
  hs.eventtap.keyStroke({"cmd"}, "Left")
  normal:exit()
  emacs:enter()
  hs.eventtap.keyStroke({}, "Return")
  hs.eventtap.keyStroke({}, "Up")
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end)

normal:bind({"shift"}, 'D', nil, function()
  normal:exit()
  emacs:enter()
  hs.eventtap.keyStroke({"ctrl"}, "k")
  normal:enter()
end)

normal:bind({}, 'f', function()
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
  hs.eventtap.keyStroke({"alt"}, "space")
end)

normal:bind({}, 's', function()
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
  hs.eventtap.keyStroke({"alt"}, "space")
end)

-- Search
normal:bind({}, '/', function() hs.eventtap.keyStroke({"cmd"}, "f") end)

-- Undo
normal:bind({}, 'u', function()
  hs.eventtap.keyStroke({"cmd"}, "z")
end)

-- Redo
normal:bind({"ctrl"}, 'r', function()
  hs.eventtap.keyStroke({"cmd", "shift"}, "z")
end)

-- Yank
normal:bind({}, 'y', function()
  hs.eventtap.keyStroke({"cmd"}, "c")
end)

-- Paste
normal:bind({}, 'p', function()
  hs.eventtap.keyStroke({"cmd"}, "v")
end)

--------------------------------------------------------------------------------
-- Emacs
--
-- Mac already has a lot of emacs keybindings by default, which is why this mode
-- has less keybindings than the vim-mode
--------------------------------------------------------------------------------

-- Switch to vim normal mode
emacs:bind({}, 'escape', function()
  emacs:exit()
  normal:enter()
  notify_user(
    'Vim',
    'Vim-mode enabled. Enter \'insert-mode\' for emacs bindings',
    vim_image
  )
end)

-- Movement related bindings
emacs:bind({"alt"}, 'b', back, nil, back)
emacs:bind({"alt"}, 'f', forward, nil, forward)

-- Deletion related bindings
emacs:bind({"ctrl"}, 'k', delete_line, nil, delete_line)
emacs:bind({"alt"}, 'delete', delete_word_forward, nil, delete_word_forward)
emacs:bind({"alt"}, 'd', delete_word_backward, nil, delete_word_backward)
