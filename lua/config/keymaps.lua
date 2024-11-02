-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>wb", "<cmd>buffer#<CR>", { desc = "Alternate buffer" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>wd", "<cmd>bdelete<CR>", { desc = "Buffer delete" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>wt", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })
map("n", "<leader>wq", "<cmd>qa<CR>", { desc = "Exit Neovim" })

if vim.F.if_nil(vim.g.elite_mode, false) then
  -- Elite-mode: Arrow-keys resize window
  map("n", "<Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
  map("n", "<Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
  map("n", "<Left>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })
  map("n", "<Right>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
else
  -- Moves through display-lines, unless count is provided
  map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
  map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
end

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Declaration" })
map("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
