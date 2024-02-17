local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  main = "ibl",
  opts = {},
}

function M.config()
  local icons = require("user.icons")

  local highlight = {
    --    "CursorColumn",
    "Whitespace",
  }

  require("ibl").setup({
    exclude = {
      filetypes = {
        "NvimTree",
        "Trouble",
        "dashboard",
        "help",
        "lazy",
        "neogitstatus",
        "startify",
        "text",
      },
    },
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = false,
    },
    indent = { char = icons.ui.LineMiddle, highlight = highlight },
    scope = { enabled = true, char = icons.ui.LineMiddle, highlight = "CursorColumn" },
  })
end

return M
