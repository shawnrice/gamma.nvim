local lua = require("user.lsp.lang.lua")

local M = {
  -- these are languages to support
  languages = {
    "bash",
    "css",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "scss",
    "sql",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    -- "csharp",
    -- "zsh",
  },
  -- these are language servers to install
  servers = {
    "lua_ls",
    --    lua_ls = lua.server,
    -- "cssls",
    -- "html",
    -- "tsserver",
    -- "eslint",
    -- "tsserver",
    -- "pyright",
    -- "bashls",
    "taplo", -- toml
    "jsonls",
    "yamlls",
  },
}

return M
