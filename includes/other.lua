--------------------------------------------------------------------------------
-- Other functions
--------------------------------------------------------------------------------

local other = {}

function other.undo()
  hs.eventtap.keyStroke({"cmd"}, "z")
end

function other.paste()
  hs.eventtap.keyStroke({"cmd"}, "v")
end

--------------------------------------------------------------------------------
-- Vim specific functions
--------------------------------------------------------------------------------

function other.vim_a()
  mode.enter_emacs()
  move.right()
end

function other.vim_shift_a()
  mode.enter_emacs()
  move.forward_line()
end

function other.vim_shift_g()
  hs.eventtap.keyStroke({"cmd"}, "Down")
end

function other.vim_i()
  mode.enter_emacs()
end

function other.vim_shift_i()
  mode.enter_emacs()
  move.backward_line()
end

function other.vim_o()
  move.forward_line()
  hs.eventtap.keyStroke({}, "Return")
end

function other.vim_shift_o()
  print("implement me")
end

--------------------------------------------------------------------------------
-- Enable / Disable hybrid mode
--------------------------------------------------------------------------------

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

return other
