local M = {
  "linrongbin16/gitlinker.nvim",
  dependencies = { { "nvim-lua/plenary.nvim" } },
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.register({
    g = {
      name = "Git",
      y = { "<cmd>GitLink!<cr>", "Git link" },
      Y = { "<cmd>GitLink blam<cr>", "Git link blame" },
    }
  }, { prefix = "<leader>"})

  require("gitlinker").setup {
    message = false,
    console_log = false,
  }
end

return M
