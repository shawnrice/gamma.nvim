local function prepare(url, name)
  return {
    url,
    priority = 1000,
    lazy = false,
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme " .. name)
    end,
  }
end

local nightfox = prepare("EdenEast/nightfox.nvim", "nordfox")

local no_clown_fiesta = prepare("aktersnurra/no-clown-fiesta.nvim", "no-clown-fiesta")

local poimandres = prepare("olivercederborg/poimandres.nvim", "poimandres")

local gruvbox_material = prepare("sainnhe/gruvbox-material", "gruvbox_material")

local everforest = prepare("sainnhe/everforest", "everforest")

local evergarden = prepare("crispybaccoon/evergarden", "evergarden")

local serenity = prepare("Wansmer/serenity.nvim", "serenity")

local M = {
  nightfox,
  no_clown_fiesta,
  evergarden,
  -- everforest,
  poimandres,
  -- gruvbox_material,
  -- nordic,
  -- serenity,
}

return M
