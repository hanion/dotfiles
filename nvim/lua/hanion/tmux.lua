local function update_tmux_window_title()
	local filename = vim.fn.expand('%:t')
	if filename == "" then
		filename = "[No Name]"
	end
	local tmux_title = filename
	vim.fn.system('tmux rename-window ' .. tmux_title)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	callback = update_tmux_window_title,
})



local function reset_tmux_window_title()
	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
	vim.fn.system('tmux rename-window ' .. cwd)
end

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
	callback = reset_tmux_window_title,
})
