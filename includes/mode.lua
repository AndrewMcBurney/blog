--------------------------------------------------------------------------------
-- Change Mode Functions
--
-- @see: Functions to change mode and notify user of the changes
--------------------------------------------------------------------------------

local other = require "hs-hybrid/includes/other"

local mode = {}

-- Modal keybindings
mode.emacs = hs.hotkey.modal.new()
mode.normal = hs.hotkey.modal.new()
mode.vim_delete = hs.hotkey.modal.new()

-- Enter vim normal mode
function mode.enter_vim_normal()
  emacs:exit()
  vim_delete:exit()
  normal:enter()
  other.notify_user('Vim', vim_message, vim_image)
end

-- Enter vim delete mode
function mode.enter_delete_modal()
  normal:exit()
  vim_delete:enter()
end

-- Enter emacs / vim insert mode
function mode.enter_emacs()
  normal:exit()
  vim_delete:exit()
  emacs:enter()
  other.notify_user('Emacs', emacs_message, emacs_image)
  last_function = null_func
end

-- Enable or disable hybrid mode
function mode.enable_or_disable_hybrid()
  if hybrid_mode_enabled then
    hybrid_mode_enabled = false
    mode.normal:exit()
    mode.vim_delete:exit()
    mode.emacs:exit()
    other.notify_user('Hybrid-mode Disabled', hybrid_disable, hybrid_image)
  else
    hybrid_mode_enabled = true
    mode.emacs:enter()
    other.notify_user('Hybrid-mode Enabled', hybrid_enable, hybrid_image)
  end
end

return mode
