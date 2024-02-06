-- @TODO I need to find a way to just disable this plugin

local M = {
  "Wansmer/symbol-usage.nvim",
  event = "BufReadPre",
}

local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

local function text_format(symbol)
  local res = {}
  local push = function(...)
    local args = { ... }
    for _, v in ipairs(args) do
      table.insert(res, v)
    end
  end

  local left = { "", "SymbolUsageRounding" }
  local right = { "", "SymbolUsageRounding" }

  if symbol.references then
    local usage = symbol.references <= 1 and "usage" or "usages"
    push(
      left,
      { "󰌹 ", "SymbolUsageRef" },
      { symbol.references .. " " .. ("%s"):format(usage), "SymbolUsageContent" },
      right
    )
  end

  if symbol.definition then
    if #res > 0 then table.insert(res, { " ", "NonText" }) end
    push(left, { "󰳽 ", "SymbolUsageDef" }, { symbol.definition .. " defs", "SymbolUsageContent" }, right)
  end

  if symbol.implementation then
    if #res > 0 then table.insert(res, { " ", "NonText" }) end
    push(left, { "󰡱 ", "SymbolUsageImpl" }, { symbol.implementation .. " impls", "SymbolUsageContent" }, right)
  end

  return res
end

function M.config()
  local opts = {
    text_format = text_format,
  }

  local mod = require("symbol-usage")

  mod.setup(opts)

  vim.api.nvim_create_user_command(
    "ToggleSymbolUsage", -- Name of the command
    mod.toggle,
    { desc = "Toggles displaying usage info on symbols", nargs = "*" }
  )

  vim.api.nvim_create_user_command(
    "ToggleSymbolUsageGlobal", -- Name of the command
    mod.toggle_globally,
    { desc = "Toggles displaying usage info on symbols", nargs = "*" }
  )

  vim.api.nvim_create_user_command(
    "RefreshSymbolUsage", -- Name of the command
    mod.refresh,
    { desc = "Refreshes usage info on symbols", nargs = "*" }
  )

  -- The mod starts enables. This will just make it start not enabled.
  --  mod.toggle_globally()
end

return M
