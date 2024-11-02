local plugin_icons = {
  DiffviewFiles = { " " },
  fugitive = { " " },
  fugitiveblame = { "󰊢", "Blame" },
  lazy = { "󰒲 ", "Lazy.nvim" },
  loclist = { "󰂖", "Location List" },
  mason = { "󰈏 ", "Mason" },
  NeogitStatus = { "󰉺" },
  ["neo-tree"] = { " ", "Neo-tree" },
  ["neo-tree-popup"] = { "󰋱", "Neo-tree" },
  Outline = { " " },
  quickfix = { " ", "Quickfix List" }, -- 󰎟 
  ["grug-far"] = { "󰥩 ", "Grug FAR" },
  spectre_panel = { "󰥩 ", "Spectre" },
  TelescopePrompt = { "󰋱", "Telescope" },
  terminal = { " " },
  toggleterm = { " ", "Terminal" },
  Trouble = { "" }, --  
  undotree = { "󰃢" },
}

local function is_file_window()
  return vim.bo.buftype == ""
end

local function is_not_prompt()
  return vim.bo.buftype ~= "prompt"
end

local function is_min_width(min)
  if vim.o.laststatus > 2 then
    return vim.o.columns > min
  end
  return vim.fn.winwidth(0) > min
end

local function filemedia(opts)
  opts = vim.tbl_extend("force", {
    separator = "  ",
  }, opts or {})
  return function()
    local parts = {}
    if vim.bo.fileformat ~= "" and vim.bo.fileformat ~= "unix" then
      table.insert(parts, vim.bo.fileformat)
    end
    if vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8" then
      table.insert(parts, vim.bo.fileencoding)
    end
    if vim.bo.filetype ~= "" then
      table.insert(parts, vim.bo.filetype)
    end
    return table.concat(parts, opts.separator)
  end
end

local function is_plugin_window()
  return vim.bo.buftype ~= ""
end

local function plugin_title()
  return function()
    -- Normalize bufname
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:len() < 1 and vim.bo.buftype:len() < 1 then
      return "N/A"
    end

    local msg = ""
    local ft = vim.bo.filetype
    local plugin_type = ft == "qf" and vim.fn.win_gettype() or ft
    if plugin_icons[plugin_type] ~= nil then
      for _, part in ipairs(plugin_icons[plugin_type]) do
        msg = msg .. " " .. part
      end
    end
    if #plugin_icons[plugin_type] < 2 then
      msg = msg .. bufname
    end
    -- % char must be escaped in statusline.
    msg = msg:gsub("%%", "%%%%")
    return msg
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      },
      sections = {
        lualine_a = {
          -- Left edge block.
          {
            function()
              return "▊"
            end,
            padding = 0,
            separator = "",
            color = function()
              local hl = is_file_window() and "Statement" or "Function"
              return LazyVim.ui.fg(hl)
            end,
          },
          {
            function()
              return ""
            end,
          },
          {
            padding = { left = 1, right = 0 },
            separator = "",
            cond = is_file_window,
            function()
              if vim.bo.buftype == "" and vim.bo.readonly then
                return icons.status.filename.readonly
              elseif vim.t["zoomed"] then
                return icons.status.filename.zoomed
              end
              return ""
            end,
          },
          "mode",
        },
        lualine_b = {
          {
            "branch",
            cond = is_file_window,
            icon = "", --  
            padding = 1,
            on_click = function()
              vim.cmd([[Telescope git_branches]])
            end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return LazyVim.ui.fg("Statement") end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return LazyVim.ui.fg("Constant") end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return LazyVim.ui.fg("Debug") end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return LazyVim.ui.fg("Special") end,
          },
        },
        lualine_y = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error .. " ",
              warn = icons.diagnostics.Warn .. " ",
              info = icons.diagnostics.Info .. " ",
              hint = icons.diagnostics.Hint .. " ",
            },
          },
          {
            filemedia(),
            padding = 1,
            cond = function()
              return is_min_width(70)
            end,
            on_click = function()
              vim.cmd([[Telescope filetypes]])
            end,
          },
        },
        lualine_z = {
          {
            function()
              if is_file_window() then
                return "%l/%2c%4p%%"
              end
              return "%l/%L"
            end,
            cond = is_not_prompt,
            padding = 1,
          },
        },
      },
      winbar = {
        lualine_c = {
          -- LazyVim.lualine.root_dir(),
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }

    -- do not add trouble symbols if aerial is enabled
    -- And allow it to be overriden for some buffer types (see autocmds)
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
