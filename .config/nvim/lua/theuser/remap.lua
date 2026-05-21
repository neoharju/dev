vim.g.mapleader = " "

local map = vim.keymap.set

-- moving lines/blocks in visual mode with indenting.
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- vertical split explore
map("n", "<leader>pv", vim.cmd.Vex, { desc = "Vertical split explorer" })

-- copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- copy file to system keyboard
map({ "n", "v" }, "<leader>Y", [[gg"+yG]], { desc = "Copy file to system keyboard" })

-- keep cursor centered for search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- make Y behave like C or D
map("n", "Y", "y$")

-- quick fix navigation
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")

-- join line and keep cursor at place with mark
map("n", "J", "mzJ`z", { desc = "Join line" })

-- delete into black hole register to avoid wiping recent yank reg
map({ "n", "v" }, "<leader>d", [["_dd]], { desc = "Delete to black hole register" })

-- Save file
map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })

-- Movement in insert mode
map("i", "<C-b>", "<ESC>^i", { desc = "beginning of line" })
map("i", "<C-e>", "<End>", { desc = "end of line" })
map("i", "<C-h>", "<Left>", { desc = "left" })
map("i", "<C-j>", "<Down>", { desc = "down" })
map("i", "<C-k>", "<Up>", { desc = "up" })
map("i", "<C-l>", "<Right>", { desc = "right" })

-- Switch window in normal mode
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
