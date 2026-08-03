-- Aggregate view of every diagnostic in the workspace -- matters more
-- once clang-tidy (via clangd) and ruff are both feeding diagnostics into
-- the same buffer alongside pyright/clangd's own.
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: workspace diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble: buffer diagnostics" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Trouble: quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: location list" },
	},
}
