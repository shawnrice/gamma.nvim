-- @see https://github.com/winston0410/smart-cursor.nvim
--
local M = {
  "winston0410/smart-cursor.nvim",
}

function M.config()
  vim.api.nvim_set_keymap(
    "n",
    "o",
    'o<cmd>lua require("smart-cursor").indent_cursor()<cr>',
    { silent = true, noremap = true }
  )
end

return M
