local M = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },
}

-- More customization options are available in the wiki
-- @see https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations

function M.config()
  vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { noremap = true, silent = true })
end

return M
