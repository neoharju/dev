local root_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim", -- Formatter
		"williamboman/mason.nvim", -- LSP/DAP/bin installer
		"williamboman/mason-lspconfig.nvim", -- Bridge Mason with lspconfig
		"hrsh7th/cmp-nvim-lsp", -- LSP completion source
		"hrsh7th/cmp-buffer", -- Buffer text as completion source
		"hrsh7th/cmp-path", -- Path completion
		"hrsh7th/cmp-cmdline", -- Snippet engine
		"hrsh7th/nvim-cmp", -- Completion engine
		"L3MON4D3/LuaSnip", -- Snippet engine
		"saadparwaiz1/cmp_luasnip", -- LuaSnip completion
		"j-hui/fidget.nvim", -- LSP Progress UI
	},

	config = function()
		require("conform").setup({
			format_on_save = {
				lsp_fallback = true,
				timout_ms = 1000,
			},
			formatters_by_ft = {
				python = { "black" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cuda = { "clang_format" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				lua = { "stylua" },
			},
		})
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({}) -- LSP progress in corner
		require("mason").setup() -- Installs LSP servers, formatters, etc.
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"pyright",
				"clangd",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									-- Put format options here
									-- NOTE: the value should be STRING!!
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					})
				end,

				-- Rust
				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = { allFeatures = true },
								checkOnSave = {
									command = "clippy",
								},
							},
						},
					})
				end,

				-- Python
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									typeCheckingMode = "basic", -- or "strict"
								},
							},
						},
					})
				end,

				-- C++ / CUDA
				["clangd"] = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						cmd = { "clangd", "--fallback-style=Google" },
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "cu" },
					})
				end,

				-- Go
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
									shadow = true,
								},
								staticcheck = true,
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
