-- @see https://github.com/Djancyp/better-comments.nvim
-- TODO this is something
-- ! This
local M = {
  "Djancyp/better-comments.nvim",
}

function M.config() require("better-comment").Setup() end

-- So this thing is super small, so if it doesn't always
-- work, then I could fork it.

return M
