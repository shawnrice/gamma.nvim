local M = {
   "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
}

function M.config()
        require("peek").setup()
        -- refer to `configuration to change defaults`
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
end

return M
