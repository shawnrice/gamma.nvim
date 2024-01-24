local M = {
"sindrets/diffview.nvim",
requires = { "nvim-lua/plenary.nvim" },
}

function M.config()
  require("diffview").setup({})
end

return M
