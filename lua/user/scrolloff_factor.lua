-- scrolloff_fraction.lua
local M = {}

-- Default configuration options
local defaults = {
  fraction = 0.25,
  absolute_filetypes = { "qf" },
  absolute_value = 0,
}

-- Store the configuration
local config = {}

-- Function to merge user options with defaults
local function setup(opts)
  opts = opts or {}
  config = vim.tbl_extend("force", defaults, opts)
end

local function scrolloff_fraction()
  local fraction = config.fraction
  if vim.fn.index(config.absolute_filetypes, vim.bo.filetype) == -1 then
    local visible_lines_in_active_window = vim.api.nvim_win_get_height(0)
    vim.o.scrolloff = math.floor(visible_lines_in_active_window * fraction)
  else
    vim.o.scrolloff = config.absolute_value
  end
end

-- Setup autocommands
local function setup_autocommands()
  vim.api.nvim_create_augroup("ScrolloffFraction", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinNew", "VimResized" }, {
    group = "ScrolloffFraction",
    pattern = "*",
    callback = scrolloff_fraction,
  })
end

-- Public setup function
function M.setup(opts)
  setup(opts)
  setup_autocommands()
end

return M
