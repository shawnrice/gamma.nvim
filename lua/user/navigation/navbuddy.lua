local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "numToStr/Comment.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VimEnter",
  opts = { lsp = { auto_attach = true } },
  init = function()
    vim.keymap.set(
      "n",
      "<leader>dS",
      "<cmd>Navbuddy<CR>",
      { silent = true, noremap = true, desc = "Open Navbuddy to preview symbols" }
    )
  end,
}

return M
