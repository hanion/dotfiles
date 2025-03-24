-- hanion nvim config file

require("hanion.remap")
require("hanion.tmux")
require("hanion.debug")
require("hanion.treesitter")
require("hanion.dev")

vim.opt.clipboard:append("unnamedplus")

vim.opt.showtabline = 1

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.api.nvim_command('set noet')
vim.opt.smartindent = true
vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/.undo/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 10

-- Disable adding newline at the end of file
vim.opt.fixendofline = false


vim.api.nvim_command('set noet')


function SetBgColors()
	--vim.api.nvim_set_hl(0, "Normal", { bg = "#121212" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#121212" })
	-- NOTE: transparent bg
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

	-- #0a0b16
	-- vim.api.nvim_win_set_hl_ns(0, 0)
	-- vim.api.nvim_win_set_hl_ns(1, 0)
	vim.cmd([[highlight clear SignColumn]])
	vim.cmd('highlight CursorLine guibg=#202020 ctermbg=235')

	local bg_color = '#202020'
	local fg_color = '#dcdcdc'
	vim.api.nvim_set_hl(0, 'MiniStatuslineMode', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, 'MiniStatuslineGit', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnostic', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, 'MiniStatuslineLineColumn', { fg = fg_color, bg = bg_color })
	vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "none" })
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "none" })

	-- vim.opt.colorcolumn = "100"
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#151515" })

	-- transparent cursor line
	if (false) then
		vim.cmd('highlight CursorLine guibg=#20202000 ctermbg=0')
	end

	if (true) then
		-- transparent statusline
		vim.cmd('highlight MiniStatuslineNormal guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineFilename guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineFiletype guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineFileinfo guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineLineColumn guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineDiagnostic guibg=NONE ctermbg=NONE')
		vim.cmd('highlight MiniStatuslineGit guibg=NONE ctermbg=NONE')

		-- transparent telescope background
		vim.cmd('highlight TelescopeNormal guibg=NONE ctermbg=NONE')
		vim.cmd('highlight TelescopeBorder guibg=NONE ctermbg=NONE')
		vim.cmd('highlight TelescopePromptNormal guibg=NONE ctermbg=NONE')
		vim.cmd('highlight TelescopePromptBorder guibg=NONE ctermbg=NONE')
		vim.cmd('highlight TelescopePreview guibg=NONE ctermbg=NONE')
		vim.cmd('highlight TelescopePreviewBorder guibg=NONE ctermbg=NONE')

		-- transparent floating window bg
		vim.cmd('highlight NormalFloat guibg=NONE ctermbg=NONE')
		vim.cmd('highlight FloatBorder guibg=NONE ctermbg=NONE')
	end
end

-- local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<C-p>", builtin.git_files)

--[[
local lspconfig = require('lspconfig')

-- Clangd setup
lspconfig.clangd.setup {
    cmd = { "clangd", "--log=verbose" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    settings = {
        clangd = {
            compilationDatabasePath = "build",
        }
    }
}


-- Ensure nvim-cmp works with LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = { "clangd", "--log=verbose" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    settings = {
        clangd = {
            compilationDatabasePath = "build",
        }
    }
}
]]


--
