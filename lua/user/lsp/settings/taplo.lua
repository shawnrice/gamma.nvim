-- taplo is for TOML
local M = {
evenBetterToml = {
      schema = {
        -- add additional schemas
        associations = {
          ['example\\.toml$'] = 'https://json.schemastore.org/example.json',
        }
      }
    }
}

return M
