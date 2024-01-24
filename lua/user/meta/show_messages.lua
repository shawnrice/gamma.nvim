local function add_separators(messages, separator)
  local lines = vim.split(messages, "\n", true)
  local separated_lines = {}
  local is_start_of_message = function(line) return vim.startswith(line, " ") == false and line:match("^%u") end

  for i, line in ipairs(lines) do
    if i ~= 1 and is_start_of_message(line) then table.insert(separated_lines, separator) end
    table.insert(separated_lines, line)
  end

  return separated_lines
end

local function clean_messages(messages)
  -- Replace carriage returns and line feeds with a newline
  messages = messages:gsub("\r\n", "\n"):gsub("\r", "\n")
  -- Split the cleaned messages
  return vim.split(messages, "\n", true)
end

-- Function to create a popup with messages
local function show_messages()
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event

  -- Capture messages
  local messages = clean_messages(vim.api.nvim_exec("messages", true))

  -- Popup options
  local popup_options = {
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = " Messages ",
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  }
  -- Initialize the popup with options
  local message_popup = Popup(popup_options)

  -- Mount the popup, which creates the buffer and window
  message_popup:mount()

  -- Now set the lines of the buffer within the popup
  local bufnr = message_popup.bufnr

  local width = math.floor(vim.o.columns * 0.8)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, messages)

  -- Map 'q' and '<Esc>' to close the popup
  message_popup:map("n", "q", function() message_popup:unmount() end, { noremap = true })

  message_popup:map("n", "<Esc>", function() message_popup:unmount() end, { noremap = true })

  -- Autocmd to close the popup when NeoVim loses focus
  message_popup:on(event.BufLeave, function() message_popup:unmount() end, { once = true })

  message_popup:on(event.BufEnter, function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end, { once = true })
end

-- Create a global command
vim.api.nvim_create_user_command("ShowMessages", show_messages, {})
