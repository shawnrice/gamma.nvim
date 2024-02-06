-- @see https://github.com/code-biscuits/nvim-biscuits

local M = {
  "code-biscuits/nvim-biscuits",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

function M.config()
  -- do stuff
  require("nvim-biscuits").setup({
    cursor_line_only = true,
  })
end

return M
