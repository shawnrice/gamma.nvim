local M = {}

function M.bindN(func, ...)
    local boundArgs = {...}
    return function(...)
        return func(table.unpack(boundArgs), ...)
    end
end

function M.notify_and_execute(command, message)
    return function()
        vim.cmd(command)
        vim.notify(message, vim.log.levels.INFO)
    end
end

function M.notify_and_feedkeys(keys, message)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
    vim.notify(message, vim.log.levels.INFO)
  end
end

-- alias to create an augroup
-- @todo document
M.augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

return M
