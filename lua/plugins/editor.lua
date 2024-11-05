return {
  -----------------------------------------------------------------------------
  -- An alternative sudo for Vim and Neovim
  -- { "lambdalisue/suda.vim", event = "BufRead" },

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

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "ToggleTerm" },
    keys = {
      {
        "<leader>tf",
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count, 0, LazyVim.root.get(), "float")
        end,
        desc = "ToggleTerm (float root_dir)",
      },
      {
        "<leader>th",
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count, 15, LazyVim.root.get(), "horizontal")
        end,
        desc = "ToggleTerm (horizontal root_dir)",
      },
      {
        "<leader>tv",
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count, vim.o.columns * 0.4, LazyVim.root.get(), "vertical")
        end,
        desc = "ToggleTerm (vertical root_dir)",
      },
      {
        "<leader>tn",
        "<cmd>ToggleTermSetName<cr>",
        desc = "Set term name",
      },
      {
        "<leader>ts",
        "<cmd>TermSelect<cr>",
        desc = "Select term",
      },
      {
        "<leader>tt",
        function()
          require("toggleterm").toggle(1, 100, LazyVim.root.get(), "tab")
        end,
        desc = "ToggleTerm (tab root_dir)",
      },
      {
        "<leader>tT",
        function()
          require("toggleterm").toggle(1, 100, vim.loop.cwd(), "tab")
        end,
        desc = "ToggleTerm (tab cwd_dir)",
      },
    },
    opts = {
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      -- on_open = fun(t: Terminal), -- function to run when the terminal opens
      -- on_close = fun(t: Terminal), -- function to run when the terminal closes
      -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
      -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
      -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      direction = "horizontal" or "vertical" or "window" or "float",
      -- direction = "vertical",
      close_on_exit = true, -- close the terminal window when the process exits
      -- shell = vim.o.shell, -- change the default shell
      -- This field is only relevant if direction is set to 'float'
      -- float_opts = {
      --   -- The border key is *almost* the same as 'nvim_open_win'
      --   -- see :h nvim_open_win for details on borders however
      --   -- the 'curved' border is a custom border type
      --   -- not natively supported but implemented in this plugin.
      --   border = 'single' or 'double' or 'shadow' or 'curved',
      --   width = <value>,
      --   height = <value>,
      --   winblend = 3,
      --   highlights = {
      --     border = "Normal",
      --     background = "Normal",
      --   }
      -- }
    },
  },

  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.editor.outline" },
  { import = "plugins.extras.editor.navic" },
  { import = "plugins.extras.editor.telescope" },
  { import = "plugins.extras.editor.sidebar" },
  { import = "plugins.extras.editor.ufo" },
}
