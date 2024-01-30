local M = {
  'b0o/incline.nvim',
  opts = {},
  -- Optional: Lazy load Incline
  event = 'VeryLazy',
}

function M.config()
require('incline').setup()
end

return M
