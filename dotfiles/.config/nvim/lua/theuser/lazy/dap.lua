return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio", -- required by dap-ui
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({})
		require("nvim-dap-virtual-text").setup({})

		-- lldb-dap ships with LLVM directly (no separate vscode-cpptools
		-- dependency). Covers C, C++, and CUDA host-side code -- device-side
		-- kernel debugging is a job for cuda-gdb/Nsight, not this.
		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb-dap",
			name = "lldb",
		}
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/build/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.cuda = dap.configurations.cpp

		require("dap-python").setup(vim.fn.exepath("python3"))

		-- auto open/close dap-ui with the debug session
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
	keys = {
		{ "<F5>", function() require("dap").continue() end, desc = "DAP: continue/start" },
		{ "<F10>", function() require("dap").step_over() end, desc = "DAP: step over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "DAP: step into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "DAP: step out" },
		{ "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
		{
			"<leader>bB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end,
			desc = "DAP: conditional breakpoint",
		},
		{ "<leader>br", function() require("dap").repl.open() end, desc = "DAP: open REPL" },
		{ "<leader>bt", function() require("dap").terminate() end, desc = "DAP: terminate" },
		{ "<leader>bu", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
	},
}

