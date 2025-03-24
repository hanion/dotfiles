-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		'rcarriga/nvim-dap-ui',

		-- Required dependency for nvim-dap-ui
		'nvim-neotest/nvim-nio',

		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		require('mason-nvim-dap').setup {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				'delve',
			},
		}






		local executable_path = nil
		local executable_directory = nil
		local entered_once = false
		local forget_executable_path = false

		-- NOTE: it will remember the exe path until dn is pressed
		-- entered once is only for setting the cwd,
		--		so we do not have to enter dir and exe path separately
		-- when <leader>dn is pressed, it will forget exe path once, and save the new one
		local function get_program_path_and_directory()
			if forget_executable_path and not entered_once then
				executable_path = nil
				executable_directory = nil
				forget_executable_path = false
			end

			if not entered_once or (not executable_path or not executable_directory) then
				executable_path = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				executable_directory = vim.fn.fnamemodify(executable_path, ':h')
				entered_once = true
			else
				if forget_executable_path then
					entered_once = false
				end
			end
			return executable_path, executable_directory
		end

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					local path, _ = get_program_path_and_directory()
					return path
				end,
				cwd = function()
					local _, directory = get_program_path_and_directory()
					return directory
				end,
				stopOnEntry = false,
				stopAtBeginningOfMainSubprogram = false,
				args = {},
			},
		}


		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		-- dapui.setup {
		-- 	-- Set icons to characters that are more likely to work in every terminal.
		-- 	--    Feel free to remove or use ones that you like more! :)
		-- 	--    Don't feel like these are good choices.
		-- 	icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
		-- 	controls = {
		-- 		icons = {
		-- 			pause = '⏸',
		-- 			play = '▶',
		-- 			step_into = '⏎',
		-- 			step_over = '⏭',
		-- 			step_out = '⏮',
		-- 			step_back = 'b',
		-- 			run_last = '▶▶',
		-- 			terminate = '⏹',
		-- 			disconnect = '⏏',
		-- 		},
		-- 	},
		-- }

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close


		-- NOTE: hanion:
		-- custom run script for engine/script_module development
		function RunScript()
			if vim.fn.filereadable('./build.sh') == 1 then
				vim.api.nvim_command('! ./build.sh')
			elseif vim.fn.filereadable('./update_script_module.sh') == 1 then
				vim.api.nvim_command('! ./update_script_module.sh')
			elseif vim.fn.filereadable('./run') == 1 then
				vim.api.nvim_command('! ./run --build')
			else
				vim.api.nvim_out_write('no build script found!\n')
			end
		end

		vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>lua RunScript()<CR>',
			{ desc = 'Run [B]uild Script', noremap = true, silent = true })


		local function build_and_run()
			RunScript()
			dap.continue()
		end

		-- NOTE: when i want to change the executable
		local function dap_new()
			forget_executable_path = true
			dap.continue()
		end

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
		vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
		vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
		vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
		vim.keymap.set('n', '<leader>do', dap.continue, { desc = 'DAP open' })
		vim.keymap.set('n', '<leader>dn', dap_new, { desc = 'DAP new (change executable path)' })
		vim.keymap.set('n', '<leader>dr', build_and_run, { desc = 'DAP build and run' })
		vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'DAP close' })
		vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>dB', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Debug: Set Breakpoint' })

		-- vim.o.makeprg = 'cmake --build ./build --config Debug'
		if vim.fn.filereadable('./build.sh') == 1 then
			vim.o.makeprg = './build.sh'
		elseif vim.fn.filereadable('./run') == 1 then
			vim.o.makeprg = './run --build'
		elseif vim.fn.filereadable('./update_script_module.sh') == 1 then
			vim.o.makeprg = './update_script_module.sh'
		end

		function RunMakeAndOpenQuickfix()
			vim.cmd('make')
			vim.cmd('copen')
		end

		vim.api.nvim_set_keymap('n', '<leader>m', ':lua RunMakeAndOpenQuickfix()<CR>', { noremap = true, silent = true })


		-- NOTE: -----------
	end,
}
