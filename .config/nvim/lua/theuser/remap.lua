vim.g.mapleader = " "

-- moving lines/blocks in visual mode with indenting.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vertical split explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Vex)
-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Keep cursor centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$")
-- quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
