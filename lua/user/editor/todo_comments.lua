-- BUG: This breaks the start screen.
-- @see https://github.com/folke/todo-comments.nvim/issues/133

-- TODO: Create more patterns that capture things like @see and @todo etc...
local M = {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}

-- TODO: This is a todo
-- NOTE: This is a note
-- HACK: this is a hack
-- FIX: This needs fix
-- BUG: TTEs
local opts = { noremap = true, silent = true }

function M.config()
  local tc = require("todo-comments")

  local function normal(keys, command)
    vim.keymap.set("n", keys, command, opts)
  end

  normal("]t", tc.jump_next)
  normal("[t", tc.jump_prev)

  tc.setup()
end

return M
