-- @see https://github.com/navarasu/onedark.nvim
local OneDark = {
  "navarasu/onedark.nvim",
  priority = 1000,
}

function OneDark.config()
  require("onedark").setup({
    style = "warmer",
  })
  require("onedark").load()
end

-- maybe use this one instead: https://github.com/luisiacc/gruvbox-baby
local M = {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd([[colorscheme gruvbox]])
  end,
  opts = {},
}

-- return OneDark
return M
