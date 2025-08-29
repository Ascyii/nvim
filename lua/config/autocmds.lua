
-- Autocommands

vim.cmd(':colorscheme gruvbox')

if vim.g.diffm then
--	vim.api.nvim_create_autocmd("VimEnter", {
--		callback = function()
--			-- Create a new empty buffer
--			vim.cmd("enew")
--
--			-- Your multiline message
--			local lines = {
--				"Welcome to Neovim!",
--				"",
--				"You are in Diff Mode!",
--				"Press <leader>do to open the Difftab.",
--				"",
--				"Good luck!"
--			}
--
--			-- Get dimensions
--			local width = vim.api.nvim_get_option("columns")
--			local height = vim.api.nvim_get_option("lines")
--
--			-- Center vertically
--			local start_line = math.floor((height - #lines) / 3)
--
--			-- Insert empty lines at the top
--			for _ = 1, start_line do
--				vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
--			end
--
--			-- Center horizontally and insert text
--			for _, line in ipairs(lines) do
--				local padding = math.floor((width - #line) / 2)
--				local padded_line = string.rep(" ", math.max(padding, 0)) .. line
--				vim.api.nvim_buf_set_lines(0, -1, -1, false, {padded_line})
--			end
--
--			-- Make buffer not modifiable
--			vim.bo.modifiable = false
--			vim.bo.buflisted = false
--		end
--	})

end


vim.api.nvim_create_user_command("Ex", function()
	if vim.opt.diff:get() then
		-- require("diffview").open()
		print("running with diff view mode -> No ex")
	else
		-- fallback if not in diff mode (optional)
		-- vim.cmd("Explore") -- or do nothing
		-- Just disable EX
		print("You have tree view (no ex anymore)")
	end
end, {})


-- Save the last file on exit
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		-- Save the last file path to a file
		local last_file = vim.fn.expand('%:p')  -- Get the absolute path of the current file
		if last_file ~= "" then
			local file = io.open(vim.fn.stdpath('data') .. "/lastfile.txt", "w")
			if file then
				file:write(last_file)
				file:close()
			end
		end
	end,
})

-- Setting a transparent background
function Transparent(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
Transparent()

