local M = {
  'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'}

function M.config()
vim.opt.termguicolors = true
require("bufferline").setup{}
end

return M
