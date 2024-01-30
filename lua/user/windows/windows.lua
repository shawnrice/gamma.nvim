local M = {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  }
}

function M.config()
  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false
  require('windows').setup()

  local function cmd(command)
    return table.concat({ '<Cmd>', command, '<CR>' })
 end
 
 -- TODO rethink these keymaps
 vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize')
 vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically')
 vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally')
 vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize')
end

return M
