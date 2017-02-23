--------------------------------------------------------------------------------
-- @submodule: hs-hybrid/trie
--
-- @usage:     Table representation of Vim command trie.
-- @author:    Andrew McBurney
--------------------------------------------------------------------------------

-- Trie representing vim keys which are non-terminal.
local vim_trie = {
  d = {
    b = delete_word_backward,
    w = delete_word_forward
  }
}
