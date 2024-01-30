local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
}

function M.config()
  local config = require("nvim-treesitter.configs")
  config.setup({
    autoinstall = true,
    autopairs = { enable = true },
    autotag = { enable = true },
    ensure_installed = require("user.lsp.options").languages,
    highlight = { 
      enable = true,
      disable = function(_, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats then return stats.size > max_filesize end
      end,
    },
    ignore_install = {},
    indent = { enable = true },
    sync_install = false,
    modules = {},
  })
end

return M
