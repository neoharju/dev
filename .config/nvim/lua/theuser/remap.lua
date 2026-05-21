vim.g.mapleader = " "

-- moving lines/blocks in visual mode with indenting.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vertical split explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Vex, { desc = "Vertical split explorer" })

-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- copy file to system keyboard
vim.keymap.set({ "n", "v" }, "<leader>Y", [[gg"+yG]], { desc = "Copy file to system keyboard" })

-- keep cursor centered for search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- make Y behave like C or D
vim.keymap.set("n", "Y", "y$")

-- quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- join line and keep cursor at place with mark
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })

-- delete into black hole register to avoid wiping recent yank reg
vim.keymap.set({ "n", "v" }, "<leader>d", [["_dd]], { desc = "Delete to black hole register" })

-- Save file
vim.keymap.set("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })
