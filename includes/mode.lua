--------------------------------------------------------------------------------
-- Change Mode Functions
--
-- @see: Functions to change mode and notify user of the changes
--------------------------------------------------------------------------------

local mode = {}

-- Enter vim normal mode
function mode.enter_vim_normal()
  emacs:exit()
  vim_delete:exit()
  normal:enter()
  notify_user('Vim', vim_message, vim_image)
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
  notify_user('Emacs', emacs_message, emacs_image)
  last_function = null_func
end

return other
