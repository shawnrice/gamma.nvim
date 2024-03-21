vim.api.nvim_create_user_command("RotateWindows", function()
  local ignored_filetypes = { "neo-tree", "fidget", "Outline", "toggleterm", "qf", "notify" }
  local window_numbers = vim.api.nvim_tabpage_list_wins(0)
  local windows_to_rotate = {}
  local active_win = vim.api.nvim_get_current_win()
  local active_win_index = nil

  -- Collect windows to rotate, excluding those with ignored filetypes
  for _, window_number in ipairs(window_numbers) do
    local buffer_number = vim.api.nvim_win_get_buf(window_number)
    local filetype = vim.bo[buffer_number].filetype

    if not vim.tbl_contains(ignored_filetypes, filetype) then
      table.insert(windows_to_rotate, {
        window_number = window_number,
        buffer_number = buffer_number,
      })
      if window_number == active_win then active_win_index = #windows_to_rotate end
    end
  end

  -- Check if there are enough windows to perform rotation
  if #windows_to_rotate < 2 then
    vim.api.nvim_err_writeln("Not enough windows to rotate.")
    return
  end

  -- Create a minimal buffer
  local minimal_buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(minimal_buffer, 0, -1, false, { "Temporary buffer" })

  -- Set each window to the minimal buffer temporarily
  for _, win_info in ipairs(windows_to_rotate) do
    vim.api.nvim_win_set_buf(win_info.window_number, minimal_buffer)
  end

  -- Rotate the original buffers
  local buffers_to_rotate = {}
  for _, win_info in ipairs(windows_to_rotate) do
    table.insert(buffers_to_rotate, win_info.buffer_number)
  end
  table.insert(buffers_to_rotate, table.remove(buffers_to_rotate, 1)) -- Perform the actual rotation

  -- Apply the rotated buffers to the windows
  for i, win_info in ipairs(windows_to_rotate) do
    vim.api.nvim_win_set_buf(win_info.window_number, buffers_to_rotate[i])
  end

  -- Optionally delete the minimal buffer if it's no longer needed
  -- vim.api.nvim_buf_delete(minimal_buffer, {force = true})

  -- Focus on the next window in the rotation
  local next_win_index = (active_win_index % #windows_to_rotate) + 1
  vim.api.nvim_set_current_win(windows_to_rotate[next_win_index].window_number)
end, {})
