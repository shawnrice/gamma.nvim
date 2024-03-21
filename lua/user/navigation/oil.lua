local M = {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      "permissions",
      "size",
      { "mtime", format = "%Y-%m-%d %H:%M:%S" },
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    lsp_rename_autosave = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr) return vim.startswith(name, ".") end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr) return false end,
      sort = {
        -- sort order can be "asc" or "desc"
        -- see :help oil-columns to see which columns are sortable
        { "type", "asc" },
        { "name", "asc" },
      },
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

return M
