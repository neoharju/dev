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
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")

		-- Base capabilities shared by all servers
		local capabilities =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"pyright",
				"clangd",
			},
			handlers = {
				-- Default handler
				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file("", true),
								},
								diagnostics = { globals = { "vim" } },
								format = { enable = false },
								telemetry = { enable = false },
							},
						},
					})
				end,

				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = { allFeatures = true },
								check = { command = "clippy" }, -- checkOnSave is deprecated
							},
						},
					})
				end,

				["pyright"] = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									typeCheckingMode = "basic",
								},
							},
						},
					})
				end,

				["clangd"] = function()
					-- clangd requires utf-16; cmp advertises utf-8 too which causes
					-- offset encoding conflicts and broken diagnostics positions.
					local clangd_caps = vim.tbl_deep_extend("force", {}, capabilities)
					clangd_caps.offsetEncoding = { "utf-16" }

					require("lspconfig").clangd.setup({
						capabilities = clangd_caps,
						on_attach = function(client)
							-- Formatting handled by conform/clang-format, not LSP
							client.server_capabilities.documentFormattingProvider = false
						end,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--completion-style=detailed",
							"--header-insertion=iwyu",
							"--offset-encoding=utf-16",
						},
						-- "cu" is a file extension, not a filetype; cuda covers .cu files
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					})
				end,

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
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			virtual_text = {
				prefix = "#",
				spacing = 4,
				source = true,
			},
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
