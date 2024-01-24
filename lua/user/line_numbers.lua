local M = {}

vim.opt.number = true
vim.opt.relativenumber = true

local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    command = "set relativenumber",
    group = numbertoggle,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    command = "set norelativenumber",
    group = numbertoggle,
})

-- Function to toggle line numbers
function M.toggle_line_numbers()
  if vim.wo.relativenumber == true then
      vim.wo.relativenumber = false
      vim.wo.number = true
  else
      vim.wo.relativenumber = true
      vim.wo.number = true
  end
end

return M
