local M = {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- @todo
  },
}

function M.config()
  local wk = require("which-key")

  wk.register({
    x = {
      name = "+Trouble",
      x = { function() require("trouble").toggle() end, "Toggle Trouble" },
      w = { function() require("trouble").toggle("workspace_diagnostics") end, "Toggle [W]orkspace diagnostics" },
      d = { function() require("trouble").toggle("document_diagnostics") end, "Toggle [D]ocument diagnostics" },
      q = { function() require("trouble").toggle("quickfix") end, "Toggle [Q]uickfix" },
      l = { function() require("trouble").toggle("loclist") end, "Toggle [l]oclist" },
    },
  }, {
    prefix = "<leader>",
  })

  vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
end

return M
