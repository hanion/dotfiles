return {
	"lmburns/lf.nvim",
	config = function()
		vim.g.lf_netrw = 1

		require("lf").setup({
			border = "single",
			direction = "float",
			winblend = 0,
			height = vim.fn.float2nr(vim.fn.round(0.8 * vim.o.lines)),
			width  = vim.fn.float2nr(vim.fn.round(0.8 * vim.o.columns)),
			escape_quit = true,
			default_file_manager = true,
		})

		vim.keymap.set("n", "<leader>l", "<Cmd>Lf<CR>")

	end,
	requires = {"toggleterm.nvim"}
}

