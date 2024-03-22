local M = {
  "IsWladi/Gittory",

  branch = "main", -- for MVP version of the plugin

  dependencies = {
    { "rcarriga/nvim-notify" }, -- optional
  },

  opts = { -- you can omit this, is the default
    atStartUp = true, -- If you want to initialize Gittory when Neovim starts

    notifySettings = {
      enabled = true, -- This flag enables the notification system, allowing Gittory to send alerts about its operational status changes.

      -- rcarriga/nvim-notify serves as the default notification plugin. However, alternative plugins can be used, provided they include the <plugin-name>.notify(message) method.            -- you can change the order of priority for the plugins or remove those you don't use.
      -- If one of the specified notification plugins is not installed, the next one in the list will be used.
      -- "print" is the native notification plugin for Neovim; it will print messages to the command line.
      -- The "print" string is included for clarity. If removed, 'print' will still be used if the other specified plugins are not installed.
      availableNotifyPlugins = { "fidget", "notify", "print" }, -- for example; you can use "fidget" instead of "notify"
    },
  },
}

return M
