local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "folke/which-key.nvim" },
    { 
      "nvim-telescope/telescope-fzf-native.nvim", 
      build = "make", 
      lazy = true,
    },
    -- @see https://github.com/crispgm/telescope-heading.nvim
    { "crispgm/telescope-heading.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
  },
}


local function setup_keymaps()
  local wk = require("which-key")

  wk.register({
    ["<leader>"] = { "<Cmd>Telescope frecency workspace=CWD<CR>", "Recent files"},
    b = {
      name = "Buffer",
      b = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
    },
    f = {
      name = "Find",
      c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
      f = { "<cmd>Telescope find_files<cr>", "Find files" },
      p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
      t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
      h = { "<cmd>Telescope help_tags<cr>", "Help" },
      l = { "<cmd>Telescope resume<cr>", "Last Search" },
      r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
    },
    g = {
      name = "Git",
      b = {
        "<cmd>Telescope git_branches<cr>", "Checkout branch"
      }
    },
  }, { prefix = "<leader>" })
end

function M.config()
  setup_keymaps()

  local icons = require("user.icons")
  local actions = require("telescope.actions")

  require("telescope").setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
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

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      live_grep = {
        theme = "dropdown",
      },

      grep_string = {
        theme = "dropdown",
      },

      find_files = {
        theme = "dropdown",
        previewer = false,
      },

      buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = true,
        show_moon = true,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_definitions = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_declarations = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_implementations = {
        theme = "dropdown",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
      heading = {
        treesitter = true,
      },
      frecency = {
        show_scores = true,
        show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      disable_devicons = false,
      }
    },
  })

  require("telescope").load_extension("frecency")
end

return M
