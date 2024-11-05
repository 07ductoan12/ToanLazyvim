function _LAZYGIT_TOGGLE()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  lazygit:toggle()
end

return {
  -----------------------------------------------------------------------------
  -- Create key bindings that stick
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cmd = "WhichKey",
    opts_extend = { "spec" },
		-- stylua: ignore
		opts = {
			defaults = {},
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					mode = { 'n', 'v' },
					{ '[',  group = 'prev' },
					{ ']',  group = 'next' },
					{ 'g',  group = 'goto' },
					{ 'gz', group = 'surround' },
					{ 'z',  group = 'fold' },
					{ ';',  group = '+telescope' },
					{ ';d', group = '+lsp' },
					{
						'<leader>b',
						group = 'buffer',
						expand = function()
							return require('which-key.extras').expand.buf()
						end,
					},
					{ '<leader>c',  group = 'code' },
					{ '<leader>w',  group = 'win' },
					{ '<leader>ch', group = 'calls' },
					{ '<leader>f',  group = 'file/find' },
					{ '<leader>fw', group = 'workspace' },
					{
						'<leader>g',
						group = 'git',
						{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
					},
					{ '<leader>h', group = 'hunks', icon = { icon = ' ', color = 'red' } },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{
						'<leader>t',
						group = 'terminal',
					},
					{ '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
					{ '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
					{
						'<leader>l',
						group = 'lsp',
						{ "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
					},

					-- Better descriptions
					{ 'gx',         desc = 'Open with system app' },

					-- DAP
					{
						"<leader>d",
						group = "Debug",
					},
					{
						"<leader>j",
						group = "Hop",
						mode = { "n", "v" },
						{ "<leader>jj", "<cmd>HopWord<cr>",      desc = "Hop word" },
						{ "<leader>jl", "<cmd>HopLine<cr>",      desc = "Hop line" },
						{ "<leader>jc", "<cmd>HopChar1<cr>",     desc = "Hop char" },
						{ "<leader>jp", "<cmd>HopPattern<cr>",   desc = "Hop arbitrary" },
						{ "<leader>ja", "<cmd>HopAnywhere<cr>",  desc = "Hop all" },
						{ "<leader>js", "<cmd>HopLineStart<cr>", desc = "Hop line start" },
					},
					{ "<leader>r",  group = "Run",                nowait = true,        remap = false },
					{ "<leader>rf", "<cmd>RunFile<CR>",           desc = "Run File",    nowait = true, remap = false },
					{ "<leader>rp", "<cmd>RunProject<CR>",        desc = "Run Project", nowait = true, remap = false },
					{ "<leader>rr", "<cmd>RunCode<CR>",           desc = "Run Code",    nowait = true, remap = false },
				},
			},
		},
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then
        LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
        wk.add(opts.defaults)
      end
    end,
  },

  -------------------------------------------

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      if vim.fn.expand("%:p") ~= "" then
        vim.cmd.edit({ bang = true })
      end
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({
        -- indent = { highlight = highlight, char = "▏" },
        indent = { highlight = highlight, char = "╎" },
        -- indent = { highlight = highlight, char = "┆" },
        -- indent = { highlight = highlight, char = "┊" },
        scope = {
          enabled = true,
          highlight = highlight,
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },

  ---------------------------------------------------------
  --- Buffer
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    enabled = not vim.g.started_by_firenvim,
    keys = {
      { "<leader>bc", "<Cmd>BufferLinePick<CR>", desc = "Tab Pick" },
    },
    opts = {
      options = {
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "icon", -- 'icon' | 'underline' | 'none',
        },
        buffer_close_icon = "󰅖",
        modified_icon = "● ",
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
        separator_style = "thick",
        show_close_icon = true,
        show_buffer_close_icons = true,
        diagnostics = "nvim_lsp",
        show_tab_indicators = true,
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        close_command = function(n)
          LazyVim.ui.bufremove(n)
        end,
        right_mouse_command = function(n)
          LazyVim.ui.bufremove(n)
        end,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. " " .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. " " .. diag.warning or "")
          return vim.trim(ret)
        end,
        custom_areas = {
          right = function()
            local result = {}
            local root = LazyVim.root()
            table.insert(result, {
              text = "%#BufferLineTab# " .. vim.fn.fnamemodify(root, ":t"),
            })

            -- Session indicator
            if vim.v.this_session ~= "" then
              table.insert(result, { text = "%#BufferLineTab#  " })
            end
            return result
          end,
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "center",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            ---@diagnostic disable-next-line: undefined-global
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- transparent
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({ -- Optional, you don't have to run setup.
        groups = {
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLine",
          "CursorLineNr",
          -- 'StatusLine',
          -- 'StatusLineNC',
          "EndOfBuffer",
        },
      })
      -- require("transparent").clear_prefix("BufferLine")
      require("transparent").clear_prefix("NeoTree")
      -- require('transparent').clear_prefix('lualine')
    end,
  },

  --------------------------------------------------------
  -- Scroll
  { import = "plugins.extras.ui.scroll", enabled = ConfigVariable.scroll },

  -----------------------------------------------------------------------------
  -- Pretty window for navigating LSP locations
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gpd", "<cmd>Glance definitions<CR>" },
      { "gpr", "<cmd>Glance references<CR>" },
      { "gpy", "<cmd>Glance type_definitions<CR>" },
      { "gpi", "<cmd>Glance implementations<CR>" },
    },
    opts = function()
      local actions = require("glance").actions
      return {
        folds = {
          fold_closed = "󰅂", -- 󰅂 
          fold_open = "󰅀", -- 󰅀 
          folded = true,
        },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["sg"] = actions.jump_vsplit,
            ["sv"] = actions.jump_split,
            ["st"] = actions.jump_tab,
            ["p"] = actions.enter_win("preview"),
          },
          preview = {
            ["q"] = actions.close,
            ["p"] = actions.enter_win("list"),
          },
        },
      }
    end,
  },

  --------------------------------------------------------
  { import = "lazyvim.plugins.extras.ui.mini-indentscope" },
  -- { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "plugins.extras.ui.alpha" },
  { import = "plugins.extras.ui.cursorword" },
  { import = "plugins.extras.ui.ccc" },
}
