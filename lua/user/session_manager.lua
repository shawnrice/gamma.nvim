local M = {
  "Shatur/neovim-session-manager",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  local Path = require("plenary.path")
  local config = require("session_manager.config")
  local session_manager = require("session_manager")

  session_manager.setup({
    -- sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
    -- session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
    -- dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.loop.cwd()` if the passed `dir` is `nil`.
    -- autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
    -- autosave_last_session = true, -- Automatically save last session on exit and on session switch.
    -- autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
    -- autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
    -- autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    --   'gitcommit',
    --   'gitrebase',
    -- },
    -- autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
    -- autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
    -- max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
  })

  local config_group = vim.api.nvim_create_augroup("NeoVimSessionManagerConfig", {}) -- A global group for all your config autocommands

  -- vim.api.nvim_create_autocmd({ "User" }, {
  --   pattern = "SessionLoadPost",
  --   group = config_group,
  --   callback = function() require("nvim-tree.api").tree.toggle(false, true) end,
  -- })
  --
  -- Auto save session
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Don't save while there's any 'nofile' buffer open.
        if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then return end
      end
      session_manager.save_current_session()
    end,
  })
end

---- Shatur/neovim-session-manager
-- Wrapper functions which persist and load additional state with the session,
-- such as whether nvim-tree is open.
M.session_save = function()
  local meta = {
    focused = vim.api.nvim_get_current_win(),
    nvimTreeOpen = false,
    nvimTreeFocused = false,
  }
  if package.loaded["nvim-tree"] and require("nvim-tree.view").is_visible() then
    meta.nvimTreeOpen = true
    meta.nvimTreeFocused = vim.fn.bufname(vim.fn.bufnr()) == "NvimTree"
    vim.cmd("NvimTreeClose")
  end

  require("treesitter-context").disable()

  vim.g.SessionMeta = vim.inspect(meta)
  require("session_manager").save_current_session()
  vim.g.SessionMeta = nil

  require("treesitter-context").enable()

  if meta.nvimTreeOpen then
    vim.cmd("NvimTreeOpen")
    if not meta.nvimTreeFocused and vim.api.nvim_win_is_valid(meta.focused) then
      vim.api.nvim_set_current_win(meta.focused)
    end
  end
end

-- Load the session associated with the CWD
M.session_load = function()
  local cb = M.new_callback(function()
    vim.schedule(function()
      local meta = loadstring("return " .. (vim.g.SessionMeta or "{}"))()
      vim.g.SessionMeta = nil
      require("user.tabline").restore_tabpage_titles()
      if meta.nvimTreeOpen then vim.cmd("NvimTreeOpen") end
      if meta.nvimTreeFocused then
        vim.cmd("NvimTreeFocus")
      elseif meta.focused and vim.api.nvim_win_is_valid(meta.focused) then
        vim.api.nvim_set_current_win(meta.focused)
      end
      require("treesitter-context").enable()
    end)
  end)

  vim.cmd(([[
    autocmd! SessionLoadPost * ++once lua require('user.fn').callback(%s)
  ]]):format(cb))

  require("treesitter-context").disable()
  require("session_manager").load_current_dir_session(false)
end

return M
