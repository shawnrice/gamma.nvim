local M = {
  json = {
      schemas = require('schemastore').json.schemas {
        select = {
          'Renovate',
          'GitHub Workflow Template Properties'
        }
      },
      validate = { enable = true },
    }
}

return M
