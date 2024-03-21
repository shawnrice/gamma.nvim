local M = {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
}

function M.config()
  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false
  require("windows").setup()

  local function cmd(command) return table.concat({ "<Cmd>", command, "<CR>" }) end

  local k = vim.keymap.set
  local opt = function(desc) return { desc = desc, noremap = true, silent = true } end
  -- TODO rethink these keymaps
  k("n", "<C-w>z", cmd("WindowsMaximize"), opt("Maximize window"))
  k("n", "<C-w>_", cmd("WindowsMaximizeVertically"), opt("Maximize window vertically"))
  k("n", "<C-w>|", cmd("WindowsMaximizeHorizontally"), opt("Maximize window horizontally"))
  k("n", "<C-w>=", cmd("WindowsEqualize"), opt("Equalize windows"))
end

return M
