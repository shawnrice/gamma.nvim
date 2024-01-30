local icons = require("user.icons")

local M = {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}

function NvimTreeTrash()
  local lib = require("nvim-tree.lib")
  local node = lib.get_node_at_cursor()
  local trash_cmd = "trash "

  local function get_user_input_char()
    local c = vim.fn.getchar()
    return vim.fn.nr2char(c)
  end

  print("Trash " .. node.name .. " ? y/n")

  if get_user_input_char():match("^y") and node then
    vim.fn.jobstart(trash_cmd .. node.absolute_path, {
      detach = true,
      on_exit = function(job_id, data, event) lib.refresh_tree() end,
    })
  end

  vim.api.nvim_command("normal :esc<CR>")
end

-- function to sort naturally
local function natural_cmp(left, right)
  left = left.name:lower()
  right = right.name:lower()

  if left == right then return false end

  for i = 1, math.max(string.len(left), string.len(right)), 1 do
    local l = string.sub(left, i, -1)
    local r = string.sub(right, i, -1)

    if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
      local l_number = tonumber(string.match(l, "^[0-9]+"))
      local r_number = tonumber(string.match(r, "^[0-9]+"))

      if l_number ~= r_number then return l_number < r_number end
    elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
      return l < r
    end
  end
end

function M.config()
  require("nvim-tree").setup({
    live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = false, -- Turn into false from true by default
    },
    sort_by = function(nodes) table.sort(nodes, natural_cmp) end,

    hijack_netrw = true,
    sync_root_with_cwd = true,
    view = {
      relativenumber = true,
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = false,
      full_name = false,
      highlight_opened_files = "none",
      root_folder_label = ":t",
      indent_width = 2,
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
      icons = {
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        glyphs = {
          default = icons.ui.Text,
          symlink = icons.ui.FileSymlink,
          bookmark = icons.ui.BookMark,
          folder = {
            arrow_closed = icons.ui.ChevronRight,
            arrow_open = icons.ui.ChevronShortDown,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      symlink_destination = true,
    },
    update_cwd = true,
    update_focused_file = {
      enable = true,
      debounce_delay = 15,
      update_root = true,
      ignore_list = {},
    },

    diagnostics = {
      enable = true,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = icons.diagnostics.BoldHint,
        info = icons.diagnostics.BoldInformation,
        warning = icons.diagnostics.BoldWarning,
        error = icons.diagnostics.BoldError,
      },
    },
  })

  local wk = require("which-key")

  wk.register({
    e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
  }, { prefix = "<leader>" })

  local api = require("nvim-tree.api")
  api.events.subscribe(api.events.Event.FileCreated, function(file) vim.cmd("edit " .. file.fname) end)

  vim.g.nvim_tree_bindings = {
    { key = "d", cb = ":lua NvimTreeTrash()<CR>" },
  }
end

return M
