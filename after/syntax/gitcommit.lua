-- Function to apply dynamic highlighting for git commit messages
local function apply_gitcommit_highlighting()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Remove any previous highlighting to avoid overlap
  vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

  -- Get the content of the current buffer (all lines)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    local line_num = i - 1 -- Lua is 1-indexed, Vim is 0-indexed

    -- Highlight the first line if over 50 characters
    if i == 1 and #line > 50 then vim.api.nvim_buf_add_highlight(bufnr, -1, "SpecialChar", line_num, 50, -1) end

    -- Highlight any line over 70 characters
    if #line > 70 then vim.api.nvim_buf_add_highlight(bufnr, -1, "Comment", line_num, 70, -1) end
  end
end

-- Attach the highlighting function to events that modify the buffer's content
local function setup_autocmds()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    pattern = "COMMIT_EDITMSG",
    callback = apply_gitcommit_highlighting,
  })
end

-- Initialize the auto commands for gitcommit highlighting
setup_autocmds()
