local icons = require("user.icons")

local M = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },
}

-- More customization options are available in the wiki
-- @see https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations

local default_component_configs = {
  container = {
    enable_character_fade = true,
  },
  indent = {
    indent_size = 2,
    padding = 1, -- extra padding on left hand side
    -- indent guides
    with_markers = true,
    indent_marker = "│",
    last_indent_marker = "└",
    highlight = "NeoTreeIndentMarker",
    -- expander config, needed for nesting files
    with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
    expander_collapsed = "",
    expander_expanded = "",
    expander_highlight = "NeoTreeExpander",
  },
  icon = {
    folder_closed = icons.ui.Folder, -- "",
    folder_open = icons.ui.FolderOpen, -- "",
    folder_empty = icons.ui.FolderEmpty, -- "󰜌",
    -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
    -- then these will never be used.
    default = "*",
    highlight = "NeoTreeFileIcon",
  },
  modified = {
    symbol = "[+]",
    highlight = "NeoTreeModified",
  },
  name = {
    trailing_slash = false,
    use_git_status_colors = true,
    highlight = "NeoTreeFileName",
  },
  git_status = {
    symbols = {
      -- Change type
      added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
      modified = "✹", -- or any icon you prefer
      --      modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
      deleted = "✖", -- this can only be used in the git_status source
      renamed = "󰁕", -- this can only be used in the git_status source
      -- Status type
      untracked = "«", -- icons.ui.FileUntracked, -- "",
      ignored = icons.ui.FileIgnored, -- "",
      unstaged = icons.ui.FileUnstaged, -- "󰄱",
      staged = icons.ui.FileStaged, -- "",
      conflict = "",
    },
  },
  -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
  file_size = {
    enabled = true,
    required_width = 64, -- min width of window required to show this column
  },
  type = {
    enabled = true,
    required_width = 122, -- min width of window required to show this column
  },
  last_modified = {
    enabled = true,
    required_width = 88, -- min width of window required to show this column
  },
  created = {
    enabled = true,
    required_width = 110, -- min width of window required to show this column
  },
  symlink_target = {
    enabled = false,
  },
}

function M.config()
  vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { noremap = true, silent = true })

  print("Setting up NeoTree")

  -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations#hide-cursor-in-neo-tree-window
  require("neo-tree").setup({
    default_component_configs = default_component_configs,

    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = icons.ui.FileUntracked, -- "",
        ignored = icons.ui.FileIgnored, -- "",
        unstaged = icons.ui.FileUnstaged, -- "󰄱",
        staged = icons.ui.FileStaged, -- "",
        conflict = "",
      },
    },

    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          -- This effectively hides the cursor
          vim.cmd("highlight! Cursor blend=100")
        end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function()
          -- Make this whatever your current Cursor highlight group is.
          vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
        end,
      },
    },
    sort_function = function(a, b)
      if a.type == b.type then
        return a.path > b.path
      else
        return a.type > b.type
      end
    end, -- this sorts files and directories descendantly
  })
end

return M
