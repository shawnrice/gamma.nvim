-- @see https://github.com/kevinhwang91/nvim-ufo#usage
local M = {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
}

function M.config()
  -- These might need to go into options
  vim.o.foldcolumn = "1" -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
  })
end

return M
