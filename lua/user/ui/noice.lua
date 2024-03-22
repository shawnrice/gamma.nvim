-- lazy.nvim
local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact", -- default, compact, minimal, simple
        stages = "fade", -- fade, fade_in_slide_out, slide, static
        -- background_colour = "#000000",
        timeout = 2500,
        top_down = true,
      },
    },
  },
}

function M.config()
  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    commands = {
      history = {
        view = "popup",
      },
      last = {
        view = "popup",
      },
      errors = {
        view = "popup",
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      { filter = { event = "emsg", find = "E20" }, skip = true },
      { filter = { event = "emsg", find = "E23" }, skip = true },
      { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
      { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
      { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
      -- { filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
      { filter = { find = "E162" }, view = "mini" },
      { filter = { find = "E37" }, skip = true },
      { filter = { find = "No signature help" }, skip = true },
      { filter = { find = "W10" }, skip = true },
    },
    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
          padding = { 1, 2 },
        },
        relative = "editor",
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 16,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      -- cmdline_popup = {
      --   position = {
      --     row = 12,
      --     col = "50%",
      --   },
      --   border = {
      --     style = "rounded",
      --     padding = { 1, 2 },
      --   },
      --   filter_options = {},
      --   win_options = {
      --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      --   },
      -- },
    },
  })

  vim.keymap.set(
    "n",
    "<leader>nl",
    function() require("noice").cmd("last") end,
    { noremap = true, silent = true, desc = "Noice last message" }
  )

  vim.keymap.set(
    "n",
    "<leader>nh",
    function() require("noice").cmd("history") end,
    { noremap = true, silent = true, desc = "Noice message [H]istory" }
  )

  require("telescope").load_extension("noice")
end

return M
