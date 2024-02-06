-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("user.options")
require("user.autocmds")
-- require("user.keymaps").setup()
vim.defer_fn(function() require("user.keymaps").setup() end, 0)
-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme " .. "nordfox")
    end,
  },

  {
    --- my show messages uses this. If nothing else does, then I should find something else
    "MunifTanjim/nui.nvim",
  },

  {
    "protex/better-digraphs.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- :Digraphs is already defined, but it's deprecated.
      -- let's make it useful
      vim.api.nvim_create_user_command("Digraphs", function()
        local mode_map = {
          ["n"] = "normal",
          ["i"] = "insert",
          ["v"] = "visual",
          -- Add other modes if needed
        }

        local current_mode = vim.api.nvim_get_mode().mode
        local mode = mode_map[current_mode]

        if mode == nil then
          return -- Leave the function if mode is not 'i', 'v', or 'n'
        end

        require("better-digraphs").digraphs(mode)
      end, {})

      -- define some things here
      vim.api.nvim_set_keymap(
        "i",
        "<C-k><C-k>",
        "<Cmd>lua require'better-digraphs'.digraphs(\"insert\")<CR>",
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "n",
        "r<C-k><C-k>",
        "<Cmd>lua require'better-digraphs'.digraphs(\"normal\")<CR>",
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "v",
        "r<C-k><C-k>",
        "<ESC><Cmd>lua require'better-digraphs'.digraphs(\"visual\")<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
}

function Spec(plugin) table.insert(plugins, { import = plugin }) end

Spec("user.navigation.leap")

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  plugins,
  require("kickstart.plugins.autoformat"),
  require("kickstart.plugins.debug"),
  require("user.ui"),
  require("user.editor"),
  change_detection = {
    enabled = true,
    notify = false,
  },
  { import = "user.plugins" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

require("user.keymaps").setup()

require("user.ui.messages")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
