local M = {}

function M.setup()
  -- [[ Basic Keymaps ]]

  local wk = require("which-key")

  wk.register({})

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Diagnostic keymaps
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
  -- @TODO this is overwritten
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

  local k = vim.keymap.set
  local opts = { noremap = true, silent = true }

  local utils = require("user.utils")

  local normal = function(keys, command) k("n", keys, command, opts) end

  local visual = function(keys, command) k("v", keys, command, opts) end

  local visual_block = function(keys, command) k("x", keys, command, opts) end

  local nox = function(keys, command) k({ "n", "o", "x" }, keys, command, opts) end

  -- Some hints for key mappings:
  -- <C- > is Ctrl + key
  -- <M- > is Alt + key
  -- <S- > is Shift + key
  -- <D- > is Cmd + key (Mac)
  -- <A- > is Cmd + key (Mac)
  -- <C-A- > is Ctrl + Cmd + key (Mac)
  -- <C-S- > is Ctrl + Shift + key
  -- <C-M- > is Ctrl + Alt + key

  -- Map space to no-op in normal mode. We're using space as our leader key.
  normal("<Space>", "<Nop>")
  -- Map Ctrl+i to Ctrl+i. This is needed for some terminal emulators.
  normal("<C-i>", "<C-i>")

  -- Normal --
  -- Better window navigation
  normal("<C-h>", "<C-w>h")
  normal("<C-j>", "<C-w>j")
  normal("<C-k>", "<C-w>k")
  normal("<C-l>", "<C-w>l")

  -- Resize with arrows
  normal("<C-Up>", ":resize +2<CR>")
  normal("<C-Down>", ":resize -2<CR>")
  normal("<C-Left>", ":vertical resize -2<CR>")
  normal("<C-Right>", ":vertical resize +2<CR>")

  -- Navigate buffers
  normal("<S-l>", ":bnext<CR>")
  normal("<S-h>", ":bprevious<CR>")

  -- Move text up and down
  normal("<A-j>", ":m .+1<CR>==")
  normal("<A-k>", ":m .-2<CR>==")

  -- Visual --
  -- Stay in indent mode
  visual("<", "<gv^")
  visual(">", ">gv^")

  normal("<D-]>", "<gv^")
  normal("<D-[", ">gv^")

  -- keep current clipboard when pasting over other text
  visual("p", '"_dP')

  -- Move text up and down
  visual("<A-j>", ":m '>+1<CR>gv=gv")
  visual("<A-k>", ":m '<-2<CR>gv=gv")

  normal("<leader>ln", require("user.editor.line_numbers").toggle_line_numbers)

  -- Shift+H and Shift+L to move to start and end of line
  nox("<s-h>", "^")
  nox("<s-l>", "g_")

  -- [[ Standard macOS things ]]
  -- Regular macOS movements
  nox("<D-Right>", "g_")
  nox("<D-Left>", "^")
  nox("<D-Up>", "gg")
  nox("<D-Down>", "G")

  vim.api.nvim_create_user_command("MoveToEndOfLineContent", function()
    vim.cmd("normal! g_")
    if vim.fn.col(".") < vim.fn.col("$") - 1 then vim.cmd("normal! l") end
  end, {})

  -- Move to the beginning or end of a lines
  k("i", "<D-Right>", "<cmd>MoveToEndOfLineContent<CR>", opts)
  k("i", "<D-Left>", "<C-\\><C-o>^", opts)
  k("i", "<D-s>", "<C-\\><C-o>:w<CR>", opts)
  nox("<D-s>", ":w<CR>")

  -- Move left or right a word
  nox("<M-Left>", "b")
  nox("<M-Right>", "w")
  k("i", "<M-Left>", "<C-\\><C-o>b", opts)
  k("i", "<M-Right>", "<C-\\><C-o>w", opts)

  -- Move up a paragraph (or block)
  nox("<M-Up>", utils.notify_and_feedkeys("{", "Use `{` to move up a block."))
  -- Move down a paragraph (or block)
  nox("<M-Down>", utils.notify_and_feedkeys("}", "Use `}` to move down a block."))

  -- opt + backspace deletes a word in normal mode
  normal("<A-Backspace>", "db")
  -- opt + backspace deletes a word in insert mode
  k("i", "<A-Backspace>", "<C-\\><C-o>db", opts)

  -- [[ -- Standard macOS things ]] --

  nox("<leader>k", ":Telescope commands<CR>")
  nox("<D-k>", ":Telescope commands<CR>k")

  nox("<leader>p", ":Telescope find_files<CR>")
  nox("<D-p>", ":Telescope find_files<CR>")

  -- Visual Block --
  -- Move text up and down
  visual_block("J", ":m '>+1<CR>gv=gv")
  visual_block("K", ":m '<-2<CR>gv=gv")
  visual_block("<A-j>", ":m '>+1<CR>gv=gv")
  visual_block("<A-k>", ":m '<-2<CR>gv=gv")

  k("n", "<C-->", "<C-^>", { desc = "Switch to last buffer", noremap = true, silent = true })

  k("n", "<leader>e", "<cmd>lua require('oil').toggle_float()<CR>", { desc = "Toggle Oil" })

  -- Center buffer while navigating
  -- normal("<C-u>", "<C-u>zz")
  -- normal("<C-d>", "<C-d>zz")
  -- normal("{", "{zz")
  -- normal("}", "}zz")
  -- normal("N", "Nzz")
  -- normal("n", "nzz")
  -- normal("G", "Gzz")
  -- normal("gg", "ggzz")
  -- normal("<C-i>", "<C-i>zz")
  -- normal("<C-o>", "<C-o>zz")
  -- normal("%", "%zz")
  -- normal("*", "*zz")
  -- normal("#", "#zz")
end

return M
