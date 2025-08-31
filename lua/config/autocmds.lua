-- Save the last file on exit
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		local last_file = vim.fn.expand('%:p') -- Get the absolute path of the current file
		if last_file ~= "" then          -- The operator means not equal in lua
			local file = io.open(vim.fn.stdpath('data') .. "/lastfile.txt", "w")
			if file then
				file:write(last_file)
				file:close()
			end
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.expandtab = true
	end,
})

vim.api.nvim_create_augroup("RememberFolds", {
	clear = true
})
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	group = "RememberFolds",
	pattern = "*",
	command = "silent! mkview",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = "RememberFolds",
	pattern = "*",
	command = "silent! loadview",
})
