local M = {
  "https://github.com/levouh/tint.nvim",
}

local DONT_TINT = true
local TINT = false

function M.config()
  require("tint").setup({
    tint = -30,
    saturation = 0.5,
    highlight_ignore_patterns = {
      "LspInlayHint.*",
      "WinBar.*",
      "WinSeparator",
      "IndentBlankline.*",
      "SignColumn",
      "EndOfBuffer",
      "Neotest*", -- for some reason Neotest window get tinted when it shouldn't
    },
    window_ignore_function = function(winid)
      -- Don't tint floating windows.
      if vim.api.nvim_win_get_config(winid).relative ~= "" then return DONT_TINT end

      local bufnr = vim.api.nvim_win_get_buf(winid)
      -- Only tint normal buffers.
      if vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then return TINT end
      return DONT_TINT
    end,
  })
end

return M
