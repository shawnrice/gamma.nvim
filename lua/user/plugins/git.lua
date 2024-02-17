local M = {
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  {
    "linrongbin16/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.register({
        -- TODO move this away from g. (g = goto, what is git?)
        h = {
          b = { "<cmd>GitLink!<cr>", "External: Open Git link" },
          B = { "<cmd>GitLink! blame<cr>", "External: Open Git link blame" },
          y = { "<cmd>GitLink<cr>", "[Y]ank Git link" },
          Y = { "<cmd>GitLink blame<cr>", "[Y]ank Git link blame" },
        },
      }, {
        prefix = "<leader>",
      })

      require("gitlinker").setup({
        message = false,
        console_log = false,
      })
    end,
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = "VimEnter",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local wk = require("which-key")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "v" }, "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "v" }, "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        -- Actions
        -- visual mode
        map(
          "v",
          "<leader>hs",
          function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "stage git hunk" }
        )
        map(
          "v",
          "<leader>hr",
          function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "reset git hunk" }
        )

        -- normal mode
        wk.register({
          h = {
            name = "Git [H]unk",
            s = { gs.stage_hunk, "Git stage hunk" },
            u = { gs.undo_stage_hunk, "Git undo stage hunk" },
            r = { gs.reset_hunk, "Git reset hunk" },
            S = { gs.stage_buffer, "Git stage buffer" },
            R = { gs.reset_buffer, "Git reset buffer" },
            p = { gs.preview_hunk, "Preview git hunk" },
            b = { function() gs.blame_line({ full = false }) end, "Git blame line" },
            d = { gs.diffthis, "Git diff against index" },
            D = { function() gs.diffthis("~") end, "Git diff against last commit" },
          },
        }, { prefix = "<leader>" })

        -- -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
      end,
    },
  },
}

return M
