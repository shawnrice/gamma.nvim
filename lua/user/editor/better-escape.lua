-- @see https://github.com/max397574/better-escape.nvim
-- Maps jk to Esc (and jj) to Esc in insert mode
-- If we need to map some more keys in insert mode,
-- then we can use: https://github.com/Krafi2/jeskape.nvim
local M = {
  "max397574/better-escape.nvim",
  config = function() require("better_escape").setup() end,
}

return M
