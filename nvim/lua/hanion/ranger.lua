---@diagnostic disable: missing-fields
return {
	"kelly-lin/ranger.nvim",
	config = function()
		require("ranger-nvim").setup({
			replace_netrw = true,
			ui = {
				height = 0.97 -- NOTE: WHY take it as percentage ???
			}
		})
		vim.api.nvim_set_keymap("n", "<leader>l", "ranger", {
			noremap = true,
			callback = function()
				require("ranger-nvim").open(true)
			end,
		})
	end,
}

