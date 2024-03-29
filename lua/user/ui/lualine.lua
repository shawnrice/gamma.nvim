local get_wakatime_time = function()
  local Job = require("plenary.job")
  local async = require("plenary.async")

  local tx, rx = async.control.channel.oneshot()
  local ok, job = pcall(Job.new, Job, {
    command = os.getenv("HOME") .. "/.wakatime/wakatime-cli",
    args = { "--today" },
    on_exit = function(j, _) tx(j:result()[1] or "") end,
  })
  if not ok then
    vim.notify("Bad WakaTime call: " .. job, "warn")
    return ""
  end

  job:start()
  return rx()
end

---@diagnostic disable
local state = { comp_wakatime_time = "" }

-- Yield statusline value
local wakatime = function()
  local async = require("plenary.async")
  local WAKATIME_UPDATE_INTERVAL = 10000

  if not Wakatime_routine_init then
    local timer = vim.loop.new_timer()
    if timer == nil then return "" end
    -- Update wakatime every 10s
    vim.loop.timer_start(timer, 500, WAKATIME_UPDATE_INTERVAL, function()
      async.run(get_wakatime_time, function(time) state.comp_wakatime_time = time end)
    end)
    Wakatime_routine_init = true
  end

  return state.comp_wakatime_time
end

local M = {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      -- Other sections
      lualine_c = {
        { "WakaTime", fmt = wakatime },

        -- Other components
        { "filetype", "progress", wakatime },
      },
      -- Other sections
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#ff9e64" },
        },
      },
    },
  },
}

return M
