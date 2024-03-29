-- Fuzzy Finder (files, lsp, etc)
local M = {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
    -- @see https://github.com/crispgm/telescope-heading.nvim
    { "crispgm/telescope-heading.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
  },
}

function M.config()
  local telescope = require("telescope")
  local telescope_builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local icons = require("user.icons")

  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  telescope.setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      --      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      layout_config = {
        prompt_position = "top",
      },
      sorting_strategy = "descending",
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = { "png", "jpg" } -- Supported image formats
            local split_path = vim.split(filepath:lower(), ".", { plain = true })
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. "\r\n")
              end
            end
            vim.fn.jobstart({
              "catimg",
              filepath, -- Terminal image viewer command
            }, { on_stdout = send_output, stdout_buffered = true, pty = true })
          else
            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          end
        end,
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    },
  })

  -- Enable telescope fzf native, if installed
  pcall(telescope.load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")

  -- Telescope live_grep in git root
  local find_git_root = require("user.git.utils").find_git_root
  -- Custom live_grep function to search in git root
  local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then telescope_builtin.live_grep({ search_dirs = { git_root } }) end
  end

  vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

  -- See `:help telescope.builtin`
  vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
  vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
  vim.keymap.set(
    "n",
    "<leader>/",
    function()
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end,
    { desc = "[/] Fuzzily search in current buffer" }
  )

  local function telescope_live_grep_open_files()
    telescope_builtin.live_grep({
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    })
  end

  require("which-key").register({
    s = {
      name = "+[S]earch",
      ["/"] = { telescope_live_grep_open_files, "[S]earch [/] in Open Files" },
      s = { telescope_builtin.builtin, "[S]earch [S]elect Telescope" },
      f = { telescope_builtin.find_files, "[S]earch [F]iles" },
      h = { telescope_builtin.help_tags, "[S]earch [H]elp" },
      w = { telescope_builtin.grep_string, "[S]earch current [W]ord" },
      g = { telescope_builtin.live_grep, "[S]earch by [G]rep" },
      G = { ":LiveGrepGitRoot<cr>", "[S]earch by [G]rep on Git Root" },
      d = { telescope_builtin.diagnostics, "[S]earch [D]iagnostics" },
      r = { telescope_builtin.resume, "[S]earch [R]esume" },
      -- gf = { telescope_builtin.git_files, "Search [G]it [F]iles" }
    },
  }, { prefix = "<leader>", mode = "n" })

  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[/] Fuzzily search in current buffer" })

  -- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it
  -- [F]iles' })
end

return M
