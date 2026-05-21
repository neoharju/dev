return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 1000, -- 5000 will visibly stall saves
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				cuda = { "clang-format" },
				go = { "gofmt" },
				lua = { "stylua" },
				python = { "ruff_format" }, -- black + ruff_format conflict; pick one
				rust = { "rustfmt" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
		end, { desc = "Format buffer" })
	end,
}
