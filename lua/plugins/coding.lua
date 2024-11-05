local M

M = {
  -----------------------------------------------------------------------------
  -- Completion plugin for neovim written in Lua
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    main = "lazyvim.util.cmp",
    dependencies = {
      -- nvim-cmp source for neovim builtin LSP client
      "hrsh7th/cmp-nvim-lsp",
      -- nvim-cmp source for buffer words
      "hrsh7th/cmp-buffer",
      -- nvim-cmp source for path
      "hrsh7th/cmp-path",
      -- nvim-cmp source for emoji
      "hrsh7th/cmp-emoji",
    },
    -- Not all LSP servers add brackets when completing a function.
    -- To better deal with this, LazyVim adds a custom option to cmp,
    -- that you can configure. For example:
    --
    -- ```lua
    -- opts = {
    --   auto_brackets = { 'python' }
    -- }
    -- ```

    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true

      local cmp_next = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end
      local cmp_prev = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end

      return {
        -- configure any filetype to auto add brackets
        auto_brackets = { "python" },
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        view = {
          entries = { follow_cursor = true },
        },
        sorting = defaults.sorting,
        experimental = {
          ghost_text = false,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 50 },
          { name = "path", priority = 40 },
        }, {
          { name = "buffer", priority = 50, keyword_length = 3 },
          { name = "emoji", insert = true, priority = 20 },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.select_next_item({ count = 5 }),
          ["<C-u>"] = cmp.mapping.select_prev_item({ count = 5 }),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-c>"] = function(fallback)
            cmp.close()
            fallback()
          end,
          ["<C-e>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end),
          ["<C-n>"] = cmp_next,
          ["<C-p>"] = cmp_prev,
        }),
        formatting = {
          format = function(entry, item)
            -- Prepend with a fancy icon from config.
            local icons = LazyVim.config.icons
            if entry.source.name == "git" then
              item.kind = icons.misc.git
            else
              local icon = icons.kinds[item.kind]
              if icon ~= nil then
                item.kind = icon .. item.kind
              end
            end
            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end
            return item
          end,
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- Native snippets
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = {
          -- Preconfigured snippets for different languages
          "rafamadriz/friendly-snippets",
        },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return LazyVim.cmp.expand(item.body)
        end,
      }
      if LazyVim.has("nvim-snippets") then
        table.insert(opts.sources, { name = "snippets" })
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Powerful auto-pair plugin with multiple characters support
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "grug-far", "spectre_panel" },
    },
    keys = {
      {
        "<leader>up",
        function()
          vim.g.autopairs_disable = not vim.g.autopairs_disable
          if vim.g.autopairs_disable then
            require("nvim-autopairs").disable()
            LazyVim.warn("Disabled auto pairs", { title = "Option" })
          else
            require("nvim-autopairs").enable()
            LazyVim.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)
    end,
  },

  {
    "abecodes/tabout.nvim",
    event = "InsertCharPre",
    -- event = 'VeryLazy',
    priority = 1000,
    config = function()
      -- tabout
      require("tabout").setup({
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Set the commentstring based on the cursor location
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- Powerful line and block-wise commenting
  {
    "numToStr/Comment.nvim",
    lazy = false,
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = function()
        -- -- Only ignore empty lines for lua files
        -- if vim.bo.filetype == "lua" then
        -- 	return "^$"
        -- end
        return "^$"
      end,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
  },

  -----------------------------------------------------------------------------
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- Manage libuv types with lazy. Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },
  -- Add lazydev source to cmp
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
  },

  { import = "lazyvim.plugins.extras.coding.neogen" },
  -- { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "plugins.extras.coding.emmet" },
  { import = "plugins.extras.coding.luasnip" },
}

if ConfigVariable.ai.codeium then
  table.insert(M, { import = "lazyvim.plugins.extras.coding.codeium" })
end

if ConfigVariable.ai.copilot then
  table.insert(M, { import = "lazyvim.plugins.extras.coding.copilot" })
end

if ConfigVariable.ai.codeium then
  table.insert(M, { import = "lazyvim.plugins.extras.coding.copilot-chat" })
end

return M
