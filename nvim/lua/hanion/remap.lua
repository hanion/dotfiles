vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>o", "<cmd>ClangdSwitchSourceHeader<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--
--
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")


-- Diagnostic keymaps
vim.keymap.set("n", "(d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", ")d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- Define the ToggleComment function
function ToggleComment()
	local start_pos = vim.fn.getpos("'<")[2]
	local end_pos = vim.fn.getpos("'>")[2]

	-- Retrieve the lines within the visual selection
	local lines = vim.fn.getline(start_pos, end_pos)

	-- Ensure `lines` is a table and not a string
	if type(lines) ~= "table" then
		print("Error: Unable to retrieve lines.")
		return
	end

	-- Check if the lines are already commented
	local is_commented = true
	for _, line in ipairs(lines) do
		if not line:match("^%s*//") then
			is_commented = false
			break
		end
	end

	if is_commented then
		-- Uncomment the lines
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^%s*//%s?", "")
		end
	else
		-- Comment the lines
		for i, line in ipairs(lines) do
			lines[i] = "// " .. line
		end
	end

	-- Update the lines in the buffer
	vim.api.nvim_buf_set_lines(0, start_pos - 1, end_pos, false, lines)
end

-- Map the function to <leader>c in visual mode
vim.api.nvim_set_keymap('v', '<leader>c', ':lua ToggleComment()<CR>', { noremap = true, silent = true })



-- Define the ToggleBlockComment function
function ToggleBlockComment()
	local line_start = vim.fn.getpos("'<")[2]
	local line_end = vim.fn.getpos("'>")[2]
	local lines = vim.fn.getline(line_start, line_end)

	-- Check if the first and last lines are already block commented
	if lines[1]:match("^%s*/%*") and lines[#lines]:match("%*/%s*$") then
		-- Uncomment the block
		lines[1] = lines[1]:gsub("^%s*/%*", "", 1)
		lines[#lines] = lines[#lines]:gsub("%*/%s*$", "", 1)
	else
		-- Comment the block
		lines[1] = "/* " .. lines[1]
		lines[#lines] = lines[#lines] .. " */"
	end

	vim.fn.setline(line_start, lines)
end

-- Map the function to <leader>b in visual mode
vim.api.nvim_set_keymap('v', '<leader>b', ':lua ToggleBlockComment()<CR>', { noremap = true, silent = true })



vim.keymap.set("n", "<leader>gt", ":Telescope git_status<CR>", { desc = "git telescope status" })
vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiffsplit, { desc = "git diff v split" })
vim.keymap.set("n", "<leader>gl", require('gitsigns').blame_line, { desc = "git line blame" })
vim.keymap.set("n", "<leader>gb", require('gitsigns').blame, { desc = "git blame" })
vim.keymap.set("n", "<leader>n", vim.cmd.Ex, { desc = "netrw" })
