return {

  -- Import LazyVim's linting spec in its entirety.
  { import = "lazyvim.plugins.linting" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- Asynchronous linter plugin
  {
    "mfussenegger/nvim-lint",
    keys = {
      {
        "<leader>cin",
        function()
          vim.notify(vim.inspect(require("lint").linters[vim.bo.filetype]))
        end,
        silent = true,
        desc = "Linter Info",
      },
    },
  },
}
