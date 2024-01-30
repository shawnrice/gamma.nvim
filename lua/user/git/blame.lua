-- @see https://github.com/f-person/git-blame.nvim
local M = {
  "f-person/git-blame.nvim",
}

function M.config()
  require("gitblame").setup({
    delay = 1000,
    display_virtual_text = true,
    enabled = false,
    highlight_group = "Comment",
    ignored_filetypes = {},
    message_template = "<date> • <author> • <sha> • <summary>",
    message_when_not_committed = "  Not Committed Yet",
    date_format = "%r",
  })
end

return M
