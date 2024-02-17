local function prepare(url, name)
  return {
    url,
    name = name,
  }
end

local nightfox = prepare("EdenEast/nightfox.nvim", "nordfox")

local no_clown_fiesta = prepare("aktersnurra/no-clown-fiesta.nvim", "no-clown-fiesta")

local poimandres = prepare("olivercederborg/poimandres.nvim", "poimandres")

local gruvbox_material = prepare("sainnhe/gruvbox-material", "gruvbox_material")

local everforest = prepare("sainnhe/everforest", "everforest")

local evergarden = prepare("crispybaccoon/evergarden", "evergarden")

local serenity = prepare("Wansmer/serenity.nvim", "serenity")

local gruvsquirrel = prepare("mikesmithgh/gruvsquirrel.nvim", "gruvsquirrel")

local M = {
  nightfox,
  no_clown_fiesta,
  evergarden,
  -- everforest,
  poimandres,
  -- gruvbox_material,
  -- nordic,
  -- serenity,
  gruvsquirrel,
}
local function activate(theme)
  theme.priority = 1000
  theme.lazy = false
  function theme.config()
    vim.o.background = "dark"
    vim.cmd("colorscheme " .. theme.name)
  end

  M.active = theme.name
end

activate(no_clown_fiesta)

return M
