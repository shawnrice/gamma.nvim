-- @see https://github.com/ellisonleao/glow.nvim
-- @see https://github.com/toppair/peek.nvim for a fuller preview
local M = {
  "ellisonleao/glow.nvim",
}

function M.config() require("glow").setup() end

return M
