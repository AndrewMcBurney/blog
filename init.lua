--------------------------------------------------------------------------------
-- @module: hs-hybrid
--
-- @usage:  System-wide Vim and Emacs keybindings for Mac
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Submodule for vim keybindings
local vim = require("hs-hybrid/trie")

-- Boolean flag for hybrid mode
local hybrid_mode_enabled = false

-- Images for notifications
local emacs_image  = hs.image.imageFromPath("./hs-hybrid/images/emacs.png")
local vim_image    = hs.image.imageFromPath("./hs-hybrid/images/vim.png")
local hybrid_image = hs.image.imageFromPath("./hs-hybrid/images/hybrid.png")

-- Modal keybindings
local emacs = hs.hotkey.modal.new()
local normal = hs.hotkey.modal.new()

-- Event listener for keys, used in vim normal mode
local listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  local keys = {'d'}
  local key_pressed = e:getCharacters()
  print(key_pressed)

  if hs.fnutils.contains(keys, key_pressed) then
    print("Found")
  else
    return false
  end
end)

-- Notify the user what mode they're in
local function notify_user(title, text, image)
  hs.notify.new({title=title, informativeText=text}):setIdImage(image):send()
end

-- Enter vim normal mode
local function enter_vim_normal_mode()
  listener:start()
  emacs:exit()
  normal:enter()
  notify_user(
    'Vim',
    'Vim-mode enabled. Enter \'insert-mode\' for emacs bindings',
    vim_image
  )
end

-- Enter emacs / vim insert mode
local function enter_emacs_and_vim_insert_mode()
  listener:stop()
  normal:exit()
  emacs:enter()
  notify_user(
    'Emacs',
    'Emacs-mode enabled. \'esc\' to enable Vim-mode',
    emacs_image
  )
end

-- Enable / Disable hybrid mode
hs.hotkey.bind({"cmd"}, "escape", function()
  if hybrid_mode_enabled then
    hybrid_mode_enabled = false
    emacs:exit()
    normal:exit()
    listener:stop()
    notify_user(
      'Hybrid-mode Disabled',
      'Hybrid-mode disabled. \'command\' + \'esc\' to enable',
      hybrid_image
    )
  else
    hybrid_mode_enabled = true
    emacs:enter()
    notify_user(
      'Hybrid-mode Enabled',
      'Hybrid-mode enabled. \'command\' + \'esc\' to disable',
      hybrid_image
    )
  end
end)

-- Movement related functions
local function right()              hs.eventtap.keyStroke({}, "Right")      end
local function left()               hs.eventtap.keyStroke({}, "Left")       end
local function up()                 hs.eventtap.keyStroke({}, "Up")         end
local function down()               hs.eventtap.keyStroke({}, "Down")       end
local function forward_word()       hs.eventtap.keyStroke({"alt"}, "Right") end
local function backward_word()      hs.eventtap.keyStroke({"alt"}, "Left")  end
local function forward_line()       hs.eventtap.keyStroke({"cmd"}, "Right") end
local function backward_line()      hs.eventtap.keyStroke({"cmd"}, "Left")  end
local function forward_paragraph()  hs.eventtap.keyStroke({"alt"}, "Up")    end
local function backward_paragraph() hs.eventtap.keyStroke({"alt"}, "Down")  end

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
  backward_line()
  hs.eventtap.keyStroke({"ctrl"}, "k")
end

local function delete()
  hs.eventtap.keyStroke({}, "delete")
end

local function fndelete()
  right()
  hs.eventtap.keyStroke({}, "delete")
end

--------------------------------------------------------------------------------
-- Vim
--
-- @see: Keybindnigs for normal vim-mode
--------------------------------------------------------------------------------

-- Movement related bindings
normal:bind({}, 'h', left, nil, left)
normal:bind({}, 'l', right, nil, right)
normal:bind({}, 'k', up, nil, up)
normal:bind({}, 'j', down, nil, down)
normal:bind({}, 'w', forward_word, nil, forward_word)
normal:bind({}, 'e', forward_word, nil, forward_word)
normal:bind({}, 'b', backward_word, nil, backward_word)

-- $
normal:bind({"shift"}, '4', forward_line, nil, forward_line)
-- ^
normal:bind({"shift"}, '6', backward_line, nil, backward_line)

-- Deletion related bindings
normal:bind({}, 'd', delete, nil, delete)
normal:bind({}, 'x', fndelete, nil, fndelete)

-- Enter insert mode
normal:bind({}, 'i', function()
  enter_emacs_and_vim_insert_mode()
end)

normal:bind({"shift"}, 'i', function()
  backward_line()
  enter_emacs_and_vim_insert_mode()
end)

normal:bind({}, 'a', function()
  right()
  enter_emacs_and_vim_insert_mode()
end)

normal:bind({"shift"}, 'a', function()
  forward_line()
  enter_emacs_and_vim_insert_mode()
end)

normal:bind({}, 'o', nil, function()
  forward_line()
  enter_emacs_and_vim_insert_mode()
  hs.eventtap.keyStroke({}, "Return")
end)

-- Paste
normal:bind({}, 'p', function()
  hs.eventtap.keyStroke({"cmd"}, "v")
end)

--------------------------------------------------------------------------------
-- Emacs
--
-- @see: Mac already has a lot of emacs keybindings by default, which is why
-- this mode has less keybindings than the vim-mode
--------------------------------------------------------------------------------

-- Switch to vim normal mode
emacs:bind({}, 'escape', function()
 enter_vim_normal_mode()
end)

-- Movement related bindings
emacs:bind({"alt"}, 'b', backward_word, nil, backward_word)
emacs:bind({"alt"}, 'f', forward_word, nil, forward_word)
emacs:bind({"alt", "shift"}, '[', forward_paragraph, nil, forward_paragraph)
emacs:bind({"alt", "shift"}, ']', backward_paragraph, nil, backward_paragraph)

-- Deletion related bindings
emacs:bind({"alt"}, 'delete', delete_word_forward, nil, delete_word_forward)
emacs:bind({"alt"}, 'd', delete_word_backward, nil, delete_word_backward)
