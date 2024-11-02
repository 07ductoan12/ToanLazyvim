return {
  -----------------------------------------------------------------------------
  -- An alternative sudo for Vim and Neovim
  { "lambdalisue/suda.vim", event = "BufRead" },

  -----------------------------------------------------------------------------
  -- Ultimate undo history visualizer
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<Leader>gu", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" },
    },
  },

  --------------------------------------------------------------
  -- Code Runner
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject" },
    config = function()
      local coderunner = require("code_runner")

      coderunner.setup({
        filetype = {
          -- java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
          -- cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          java = "mkdir -p ~/out && cd $dir && javac -d ~/out $fileName && java -cp ~/out $fileNameWithoutExt",
          python = "python3 -u",
          typescript = "deno run",
          javascript = "node $dir/$fileName",
          dart = "dart $fileName",
          rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
          cpp = "mkdir -p ~/out && cd $dir && g++ $fileName -o ~/out/$fileNameWithoutExt && ~/out/$fileNameWithoutExt",
          c = "mkdir -p ~/out && cd $dir && gcc $fileName -o ~/out/$fileNameWithoutExt && ~/out/$fileNameWithoutExt",
          scss = "sass $dir/$fileName $dir/$fileNameWithoutExt.css",
          lua = "cd $dir && lua $fileName",
        },
        mode = "float", -- "float", "term", "tab"
        focus = true,
        startinsert = true,
        term = {
          -- position = "vert",
          position = "bot",
          size = 10,
        },
        float = {
          -- Key that close the code_runner floating window
          close_key = "<ESC>",
          -- Window border (see ':h nvim_open_win')
          -- border = "solid",
          border = "rounded",

          -- Num from `0 - 1` for measurements
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,

          -- Highlight group for floating window/border (see ':h winhl')
          border_hl = "FloatBorder",
          float_hl = "Normal",

          -- Transparency (see ':h winblend')
          blend = 0,
        },
        project_path = vim.fn.expand("~/.config/nvim/project_manager.json"),
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Search labels, enhanced character motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
		-- stylua: ignore
		keys = {
			{ 'ss', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,   desc = 'Flash' },
			{
				'S',
				mode = { 'n', 'x', 'o' },
				function()
					require('flash')
							.treesitter()
				end,
				desc = 'Flash Treesitter'
			},
			{ 'r',  mode = 'o',               function() require('flash').remote() end, desc = 'Remote Flash' },
			{
				'R',
				mode = { 'x', 'o' },
				function()
					require('flash')
							.treesitter_search()
				end,
				desc = 'Treesitter Search'
			},
			{ '<C-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
		},
  },

  -----------------------------------------------------------------------------
  -- Navbuddy
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = { auto_attach = true },
      -- window = { sections = { right = { preview = 'always' } } },
      window = {
        border = "rounded",
        position = { row = 1, col = "100%" },
        size = { width = "70%", height = "30%" },
        sections = {
          left = {
            size = "33%",
            border = nil,
          },
          mid = {
            size = "33%",
            border = nil,
          },
          right = {
            border = nil,
            preview = "leaf",
          },
        },
      },
      mappings = {
        -- structured like this to avoid having to `require('nvim-navbuddy')` during startup
        ["/"] = {
          callback = function(display)
            local nvim_navbuddy_telescope = require("nvim-navbuddy.actions").telescope({
              layout_strategy = "horizontal",
              layout_config = {
                height = 0.60,
                width = 0.60,
                preview_width = 0.50,
              },
            })
            return nvim_navbuddy_telescope.callback(display)
          end,
          description = "Fuzzy search current level with telescope",
        },
      },
    },
    keys = {
      {
        "<leader>cb",
        function()
          require("nvim-navbuddy").open()
        end,
        desc = "Jump to symbol",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Fancy window picker
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    keys = function(_, keys)
      local pick_window = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id ~= nil then
          vim.api.nvim_set_current_win(picked_window_id)
        end
      end

      local swap_window = function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id ~= nil then
          local current_winnr = vim.api.nvim_get_current_win()
          local current_bufnr = vim.api.nvim_get_current_buf()
          local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
          vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
          vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
        end
      end

      local mappings = {
        { "<leader>wp", pick_window, desc = "Pick window" },
        { "<leader>ww", swap_window, desc = "Swap picked window" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        bo = {
          filetype = { "notify", "noice", "neo-tree-popup" },
          buftype = { "prompt", "nofile", "quickfix" },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  {
    "smoka7/hop.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
  },

  {
    "smjonas/inc-rename.nvim",
    dependencies = {
      {
        "folke/noice.nvim",
        optional = true,
        opts = {
          presets = { inc_rename = true },
        },
      },
    },
    config = function()
      require("inc_rename").setup({})
      vim.keymap.set("n", "<leader>cr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "rename" })
    end,
  },

  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.editor.outline" },
  { import = "plugins.extras.editor.navic" },
  { import = "plugins.extras.editor.telescope" },
  { import = "plugins.extras.editor.sidebar" },
  { import = "plugins.extras.editor.ufo" },
}
