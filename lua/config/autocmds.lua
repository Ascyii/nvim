-- Save the last file on exit
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		-- Save the last file path to a file
		local last_file = vim.fn.expand('%:p') -- Get the absolute path of the current file
		if last_file ~= "" then
			local file = io.open(vim.fn.stdpath('data') .. "/lastfile.txt", "w")
			if file then
				file:write(last_file)
				file:close()
			end
		end
	end,
})
