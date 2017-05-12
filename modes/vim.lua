--------------------------------------------------------------------------------
-- Vim normal mode
--
-- @see: Keybindings for normal vim-mode. Bind these to nil so they don't have
-- an effect on the key listener
--------------------------------------------------------------------------------

local mode = require "hs-hybrid/includes/mode"

-- Lowercase
mode.normal:bind({}, 'a', function() vim_a() end)
mode.normal:bind({}, 'b', function() execute_function( move.backward_word ) end)
mode.normal:bind({}, 'd', function() mode.enter_delete_modal() end)
mode.normal:bind({}, 'e', function() execute_function( move.forward_word ) end)
mode.normal:bind({}, 'h', function() execute_function( move.left ) end)
mode.normal:bind({}, 'i', function() vim_i() end)
mode.normal:bind({}, 'j', function() execute_function( move.down ) end)
mode.normal:bind({}, 'k', function() execute_function( move.up ) end)
mode.normal:bind({}, 'l', function() execute_function( move.right ) end)
mode.normal:bind({}, 'o', function() vim_o() end)
mode.normal:bind({}, 'p', function() execute_function( paste ) end)
mode.normal:bind({}, 'u', function() execute_function( undo ) end)
mode.normal:bind({}, 'w', function() execute_function( move.forward_word ) end)
mode.normal:bind({}, 'x', function() execute_function( delete.fndelete ) end)

-- Uppercase
mode.normal:bind({"shift"}, 'a', function() vim_shift_a() end)
mode.normal:bind({"shift"}, 'g', function() execute_function( vim_shift_g ) end)
mode.normal:bind({"shift"}, 'i', function() vim_shift_i() end)
mode.normal:bind({"shift"}, 'o', function() vim_shift_o() end)

-- Numbers
mode.normal:bind({}, '0', function() set_number(0) end)
mode.normal:bind({}, '1', function() set_number(1) end)
mode.normal:bind({}, '2', function() set_number(2) end)
mode.normal:bind({}, '3', function() set_number(3) end)
mode.normal:bind({}, '4', function() set_number(4) end)
mode.normal:bind({}, '5', function() set_number(5) end)
mode.normal:bind({}, '6', function() set_number(6) end)
mode.normal:bind({}, '7', function() set_number(7) end)
mode.normal:bind({}, '8', function() set_number(8) end)
mode.normal:bind({}, '9', function() set_number(9) end)

-- Symbols
mode.normal:bind({"shift"}, '0', function() end)
mode.normal:bind({"shift"}, '1', function() end)
mode.normal:bind({"shift"}, '2', function() end)
mode.normal:bind({"shift"}, '3', function() end)
mode.normal:bind({"shift"}, '4', function() execute_function( move.forward_line ) end)
mode.normal:bind({"shift"}, '5', function() end)
mode.normal:bind({"shift"}, '6', function() execute_function( move.backward_line ) end)
mode.normal:bind({"shift"}, '7', function() end)
mode.normal:bind({"shift"}, '8', function() end)
mode.normal:bind({"shift"}, '9', function() end)

-- Other
mode.normal:bind({}, '.', function() execute_function( last_function ) end)
mode.normal:bind({}, 'escape', function() number = 0 end)

--------------------------------------------------------------------------------
-- Vim delete mode
--
-- @see: Special modal mode for deletion related keybindings once 'd' key has
-- been pressed
--------------------------------------------------------------------------------

mode.vim_delete:bind({}, 'b', function() execute_function( delete.vim.word_backward ) end)
mode.vim_delete:bind({}, 'd', function() execute_function( delete.vim.line ) end)
mode.vim_delete:bind({}, 'e', function() execute_function( delete.vim.word_forward ) end)
mode.vim_delete:bind({}, 'w', function() execute_function( delete.vim.word_forward ) end)

mode.vim_delete:bind({"shift"}, '4', function() execute_function( delete.vim.forward_line ) end)
mode.vim_delete:bind({"shift"}, '6', function() execute_function( delete.vim.backward_line ) end)
