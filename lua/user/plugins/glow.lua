-- @see https://github.com/ellisonleao/glow.nvim
-- @see https://github.com/toppair/peek.nvim for a fuller preview
local M = {
  "ellisonleao/glow.nvim",
  -- do not load until we go into a markdown file
  ft = "markdown",
}

function M.config() require("glow").setup() end

return M
