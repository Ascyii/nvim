local M = {}

local journal_base = vim.fn.expand("~/management/brainstore/knowledge/journal")

M.open_today = function()
	local date = os.date("*t")
	local day = os.date("%d")
	local month = os.date("%m")
	local year = tostring(date.year)

	-- Define the filename and full path
	local filename = string.format("%s.%s.md", day, month)
	local full_path = string.format("%s/%s/%s", journal_base, year, filename)

	-- Create the year folder if it doesn't exist
	vim.fn.system({ "mkdir", "-p", journal_base .. "/" .. year })

	-- Check if the file exists and create it if not
	local file = io.open(full_path, "r")
	if not file then
		-- If the file does not exist, create and write the header
		local header = string.format("# Journal Entry - [[date:%s]]\n\n", os.date("%d.%m.%y"))
		file = io.open(full_path, "w")
		if file == nil then
			return
		end
		file:write(header)
		file:close()
	end

	-- Open the file for editing
	vim.cmd("edit " .. full_path)
	vim.cmd("normal! G")
end


M.search_this_month = function()
	local date = os.date("*t")

	local month = os.date("%m")
	local year = tostring(date.year)

	local path = string.format("%s/%s", journal_base, year)

	-- Use telescope or fzf-lua
	require('telescope.builtin').find_files {
		prompt_title = "Journal Entries This Month",
		cwd = path,
		find_command = {
			"rg", "--files", "--glob", "*.md", "-e", string.format("^\\d\\d.%s.md", month)
		},
	}
end


M.list_all_journals = function()
	-- Use telescope or fzf-lua
	require('telescope.builtin').find_files {
		prompt_title = "All Journal Entries",
		cwd = journal_base,  -- Start from the base folder
		find_command = {
			"rg", "--files", "--glob", "*/??.??.md",
		},
	}
end

return M

