local M = {}

local lua_ls = {
  Lua = {
    workspace = { checkThirdParty = false },
    telescope = { enable = false },
    -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
    -- diagnostics = { disable = { 'missing-fields' } },
  },
}

M.server = lua_ls

return M
