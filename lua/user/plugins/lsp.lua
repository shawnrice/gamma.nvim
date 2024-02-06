-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
local M = {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },
}

function M.config()
  -- Setup neovim lua configuration
  require("neodev").setup()

  -- [[ Configure LSP ]]
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then desc = "LSP: " .. desc end

      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    local wk = require("which-key")
    local telescope_builtin = require("telescope.builtin")

    wk.register({
      w = {
        name = "+[W]orkspace",
        a = {
          vim.lsp.buf.add_workspace_folder,
          "LSP: [W]orkspace [A]dd Folder",
        },
        r = {
          vim.lsp.buf.remove_workspace_folder,
          "LSP: [W]orkspace [R]emove Folder",
        },
        l = {
          function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          "LSP: [W]orkspace [L]ist Folders",
        },
        s = {
          telescope_builtin.lsp_dynamic_workspace_symbols,
          "LSP: Search [S]ymbols",
        },
      },
    }, { prefix = "<leader>", buffer = bufnr })

    nmap("<F2>", vim.lsp.buf.rename, "Rename symbol")
    -- nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    wk.register({
      g = {
        name = "[G]oto",
        d = { telescope_builtin.lsp_definitions, "[G]oto [D]efinition" },
        D = { vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
        r = { telescope_builtin.lsp_references, "[G]oto [R]eferences" },
        I = { telescope_builtin.lsp_implementations, "[G]oto [I]mplementation" },
      },
    })

    wk.register({
      c = {
        name = "[C]ode",
        a = {
          function() vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } }) end,
          "[C]ode [A]ction",
        },
      },
    }, { prefix = "<leader>" })

    nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "Format",
      function(_) vim.lsp.buf.format() end,
      { desc = "Format current buffer with LSP" }
    )
  end

  -- mason-lspconfig requires that these setup functions are called in this order
  -- before setting up the servers.
  require("mason").setup()
  require("mason-lspconfig").setup()

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  --
  --  If you want to override the default filetypes that your language server will attach to you can
  --  define the property 'filetypes' to the map in question.
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = "LuaJIT",
        },
        format = {
          enable = false,
        },
        hint = {
          enable = true,
          setType = true,
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  }

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- Ensure the servers above are installed
  local mason_lspconfig = require("mason-lspconfig")

  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
  })

  mason_lspconfig.setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      })
    end,
  })
end

return M
