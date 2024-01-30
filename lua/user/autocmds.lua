-- Re-highlight selection when yanking
vim.api.nvim_create_augroup("YankReselect", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankReselect",
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then vim.cmd("normal! gv") end
  end,
})
