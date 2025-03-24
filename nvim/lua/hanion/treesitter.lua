local context_enabled = true

function ToggleTreesitterContext()
	if context_enabled then
		require('treesitter-context').disable()
	else
		require('treesitter-context').enable()
	end
	context_enabled = not context_enabled
end

vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd>lua ToggleTreesitterContext()<CR>', { noremap = true, silent = true })
