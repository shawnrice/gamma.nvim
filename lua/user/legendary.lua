local M = {

    'mrjones2014/legendary.nvim',
    version = 'v2.1.0',
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = { 
      'kkharji/sqlite.lua',
      'stevearc/dressing.nvim',
    }

}

function M.config()
  require('legendary').setup({ 
    -- lazy_nvim = { auto_register = true } 
  })
end

return M
