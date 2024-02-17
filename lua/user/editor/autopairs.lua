local M = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
}

M.config = function()
  require("nvim-autopairs").setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
  })

  -- If you want to automatically add `(` after selecting a function or method
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
