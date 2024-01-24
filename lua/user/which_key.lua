local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {},
}

function M.config()
  local wk = require("which-key")
  local utils = require("user.utils")

  local opts = { noremap = true, silent = true }

  -- Normal mode mappings
  local normalMappings = {
      ["<C-h>"] = { "<C-w>h", "Move Left in Window" },
      ["<C-j>"] = { "<C-w>j", "Move Down in Window" },
      ["<C-k>"] = { "<C-w>k", "Move Up in Window" },
      ["<C-l>"] = { "<C-w>l", "Move Right in Window" },
      ["<C-Up>"] = { ":resize +2<CR>", "Increase Window Height" },
      ["<C-Down>"] = { ":resize -2<CR>", "Decrease Window Height" },
      ["<C-Left>"] = { ":vertical resize -2<CR>", "Decrease Window Width" },
      ["<C-Right>"] = { ":vertical resize +2<CR>", "Increase Window Width" },
      ["<S-l>"] = { ":bnext<CR>", "Next Buffer" },
      ["<S-h>"] = { ":bprevious<CR>", "Previous Buffer" },
      ["<A-j>"] = { ":m .+1<CR>==", "Move Line Down" },
      ["<A-k>"] = { ":m .-2<CR>==", "Move Line Up" },
      ["<leader>ln"] = { require("user.line_numbers").toggle_line_numbers, "Toggle Line Numbers" },
      ["<s-h>"] = { "^", "Start of Line" },
      ["<s-l>"] = { "g_", "End of Line" },
      ["<D-Right>"] = { "g_", "End of Line (macOS)" },
      ["<D-Left>"] = { "^", "Start of Line (macOS)" },
      ["<D-Up>"] = { "gg", "Start of Document (macOS)" },
      ["<D-Down>"] = { "G", "End of Document (macOS)" },
      ["<M-Left>"] = { "b", "Previous Word (macOS)" },
      ["<M-Right>"] = { "w", "Next Word (macOS)" },
      -- ["<M-Up>"] = { utils.notify_and_feedkeys('{', "Move Up a Block (macOS)"), "Previous Paragraph" },
      -- ["<M-Down>"] = { utils.notify_and_feedkeys('}', "Move Down a Block (macOS)"), "Next Paragraph" },
      ["<leader>k"] = { ":Telescope commands<CR>", "Telescope Commands" },
      ["<D-k>"] = { ":Telescope commands<CR>", "Telescope Commands (macOS)" },
      ["<leader>p"] = { ":Telescope find_files<CR>", "Telescope Find Files" },
      ["<D-p>"] = { ":Telescope find_files<CR>", "Telescope Find Files (macOS)" },
  }
  
  -- Register the normal mode mappings with which-key
  wk.register(normalMappings, { mode = "n" })

  -- Visual mode mappings
  local visualMappings = {
    ["<"] = { "<gv^", "Indent Left and Reselect" },
    [">"] = { ">gv^", "Indent Right and Reselect" },
    ["p"] = { '"_dP', "Paste and Keep Clipboard" },
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move Lines Down" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move Lines Up" },
  }

  -- Register the visual mode mappings with which-key
  wk.register(visualMappings, { mode = "v" })

  -- 'nox' mode mappings (Normal, Operator-pending, and Visual Block modes)
local noxMappings = {
  ["<s-h>"] = { "^", "Start of Line" },
  ["<s-l>"] = { "g_", "End of Line" },
  ["<D-Right>"] = { "g_", "End of Line (macOS)" },
  ["<D-Left>"] = { "^", "Start of Line (macOS)" },
  ["<D-Up>"] = { "gg", "Start of Document (macOS)" },
  ["<D-Down>"] = { "G", "End of Document (macOS)" },
  ["<M-Left>"] = { "b", "Previous Word (macOS)" },
  ["<M-Right>"] = { "w", "Next Word (macOS)" },
  ["<M-Up>"] = { utils.notify_and_feedkeys('{', "Move Up a Block (macOS)"), "Previous Paragraph" },
  ["<M-Down>"] = { utils.notify_and_feedkeys('}', "Move Down a Block (macOS)"), "Next Paragraph" },
  ["<leader>k"] = { ":Telescope commands<CR>", "Telescope Commands" },
  ["<D-k>"] = { ":Telescope commands<CR>", "Telescope Commands (macOS)" },
  ["<leader>p"] = { ":Telescope find_files<CR>", "Telescope Find Files" },
  ["<D-p>"] = { ":Telescope find_files<CR>", "Telescope Find Files (macOS)" },
}

  -- Register the 'nox' mode mappings with which-key
  wk.register(noxMappings, { mode = "n" })  -- For normal mode
  wk.register(noxMappings, { mode = "o" })  -- For operator-pending mode
  wk.register(noxMappings, { mode = "x" })  -- For visual block mode
  
  -- Visual Block mode mappings
local visualBlockMappings = {
  ["J"] = { ":m '>+1<CR>gv=gv", "Move Block Down" },
  ["K"] = { ":m '<-2<CR>gv=gv", "Move Block Up" },
  ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move Block Down (Alt)" },
  ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move Block Up (Alt)" },
}

-- Register the visual block mode mappings with which-key
wk.register(visualBlockMappings, { mode = "x" })
end

return M
