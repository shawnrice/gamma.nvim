-- @see https://github.com/navarasu/onedark.nvim
local OneDark = {
  repo = "navarasu/onedark.nvim",
  name = "onedark",
  options = { style = "warmer" },
}

local GruvBox = {
  repo = "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  options = {},
}

-- @see https://github.com/EdenEast/nightfox.nvim
local NightFox = {
  repo = "EdenEast/nightfox.nvim",
  name = "carbonfox",
  options = {},
}

function OneDark.config()
  require("onedark").setup({
    style = "warmer",
  })
  require("onedark").load()
end

local function toTheme(theme)
  return {
    theme.repo,
    priority = 1000,
    config = theme.config or function()
      vim.o.background = "dark"
      vim.cmd("colorscheme " .. theme.name)
    end,
  }
end

return toTheme(NightFox)
