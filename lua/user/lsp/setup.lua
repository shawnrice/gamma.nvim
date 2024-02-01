local icons = require("user.icons")
local lsp_options = require("user.lsp.options")
local treesitter = require("user.lsp.treesitter")

local lsp = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
  },
}

function lsp.lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap

  -- @todo Move this to keymap.lua

  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

function lsp.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

function lsp.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

lsp.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  if client.supports_method("textDocument/inlayHint") then vim.lsp.inlay_hint.enable(bufnr, true) end
end

local function keymaps()
  local wk = require("which-key")
  wk.register({
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = {
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      "Format",
    },
    i = { "<cmd>LspInfo<cr>", "Info" },
    j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    h = { "<cmd>lua require('user.lsp').toggle_inlay_hints()<cr>", "Hints" },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
  }, { prefix = "<leader>l" })

  wk.register({
    ["<leader>la"] = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action", mode = "v" },
    },
  })
end

local default_diagnostic_config = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = icons.diagnostics.Error },
      { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

-- This function gets called when an LSP attaches to a buffer.
local function on_attach(_, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local buf = vim.lsp.buf
  local telescope = require("telescope.builtin")

  nmap("<leader>rn", buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", buf.code_action, "[C]ode [A]ction")

  nmap("gd", telescope.lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", telescope.lsp_references, "[G]oto [R]eferences")
  nmap("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
  nmap("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", buf.hover, "Hover Documentation")
  nmap("<C-k>", buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function() print(vim.inspect(buf.list_workspace_folders())) end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Format",
    function(_) vim.lsp.buf.format() end,
    { desc = "Format current buffer with LSP" }
  )
end

function lsp.config()
  local lspconfig = require("lspconfig")

  -- register global keymaps
  keymaps()

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  local servers = lsp_options.servers

  for _, server in pairs(servers) do
    local opts = {
      on_attach = lsp.on_attach,
      capabilities = lsp.common_capabilities(),
    }

    local require_ok, settings = pcall(require, "user.lsp.settings." .. server)
    if require_ok then opts = vim.tbl_deep_extend("force", settings, opts) end

    if server == "lua_ls" then require("neodev").setup({}) end

    lspconfig[server].setup(opts)
  end
end

-- function lsp.config()
--   -- document existing key chains
--   require("which-key").register({
--     c = { name = "[C]ode", _ = "which_key_ignore" },
--     d = { name = "[D]ocument", _ = "which_key_ignore" },
--     g = { name = "[G]it", _ = "which_key_ignore" },
--     h = { name = "More git", _ = "which_key_ignore" },
--     r = { name = "[R]ename", _ = "which_key_ignore" },
--     s = { name = "[S]earch", _ = "which_key_ignore" },
--     w = { name = "[W]orkspace", _ = "which_key_ignore" },
--   }, { prefix = "<leader>" })

--   -- mason-lspconfig requires that these setup functions are called in this order before setting up the servers.
--   require("mason").setup()
--   require("mason-lspconfig").setup()

--   -- Setup neovim lua configuration
--   require("neodev").setup()

--   -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
--   local capabilities = vim.lsp.protocol.make_client_capabilities()
--   capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

--   -- Ensure the servers above are installed
--   local mason_lspconfig = require("mason-lspconfig")

--   local servers = lsp_options.servers

--   mason_lspconfig.setup({
--     ensure_installed = vim.tbl_keys(servers),
--   })

--   mason_lspconfig.setup_handlers({
--     function(server_name)
--       require("lspconfig")[server_name].setup({
--         capabilities = capabilities,
--         on_attach = on_attach,
--         settings = servers[server_name],
--         filetypes = (servers[server_name] or {}).filetypes,
--       })
--     end,
--   })
-- end

return lsp
