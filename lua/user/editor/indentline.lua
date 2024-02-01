local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  main = "ibl",
  opts = {},
}

function M.config()
  local icons = require("user.icons")

  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local hooks = require("ibl.hooks")
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  require("ibl").setup({
    --    buftype_exclude = { "terminal", "nofile" },
    -- filetype_exclude = {
    --   "help",
    --   "startify",
    --   "dashboard",
    --   "lazy",
    --   "neogitstatus",
    --   "NvimTree",
    --   "Trouble",
    --   "text",
    -- },
    -- char = icons.ui.LineLeft,
    -- char = icons.ui.LineMiddle,
    -- context_char = icons.ui.LineLeft,
    -- context_char = icons.ui.LineMiddle,
    indent = { char = icons.ui.LineMiddle, highlight = highlight },
    -- show_trailing_blankline_indent = false,
    -- show_first_indent_level = true,
    -- use_treesitter = true,
    scope = { enabled = false },
    -- show_current_context = true,
    whitespace = {
      remove_blankline_trail = true,
    },
  })
end

return M
