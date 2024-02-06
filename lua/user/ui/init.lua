local M = {
  require("user.ui.barbecue"),
  require("user.ui.bufferline"),
  require("user.ui.incline"),
  require("user.ui.lualine"),
  require("user.ui.tint"),
  require("user.ui.windows"),
  require("user.ui.winshift"),
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- ! Fix the below
  require("user.ui.goto_preview"),
  require("user.ui.sidebar"),
  require("user.ui.symbol_usage"),
  require("user.ui.toggleterm"),
}

return M
