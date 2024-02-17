local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    --[[ things you want to change go here]]
  },
}

-- @see https://github.com/akinsho/toggleterm.nvim
-- See a whole lot more here

function M.config()
  require("toggleterm").setup({
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-`>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = "float", -- 'vertical' | 'horizontal' | 'window' | 'float'
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders e.g. combine letters with numbers (eg: '10' or '1')
      -- single, double, shadow, none
      border = "single",
      width = 100,
      height = 100,
      winblend = 3,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  })
end

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 } -- Sets the keymap for the current terminal buffer only
  vim.keymap.set("t", "<C-`>", [[<C-\><C-n>:q<CR>]], opts) -- Map <esc> to exit terminal mode and close the terminal
  -- You can replace '<esc>' with any key sequence of your choice.
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

return M
