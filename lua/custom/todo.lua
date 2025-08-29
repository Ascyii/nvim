-- custom module for todo file editing support in neovim
-- inspired by a older plugin that does basically the same

local M = {}

local function is_todo_file()
	return vim.fn.expand("%:t") == "todo.txt"
end

function M.set_priority(letter)
	if not is_todo_file() then return end
	local line = vim.api.nvim_get_current_line()
	line = line:gsub("^%(%u%)%s*", "")
	vim.api.nvim_set_current_line(string.format("(%s) %s", letter:upper(), line))
end

-- Remove priority
function M.remove_priority()
	if not is_todo_file() then return end
	local line = vim.api.nvim_get_current_line()
	line = line:gsub("^%(%u%)%s*", "")
	vim.api.nvim_set_current_line(line)
end

local function strip_ansi(s)
  return   s:gsub("\27%[[0-9;]*m", "")
end

function M.mark_done()
	if not is_todo_file() then return end

	--local line = vim.api.nvim_get_current_line():match("^%s*(.-)%s*$")

	--local tasks = vim.fn.systemlist("todo.sh list")
	--for _, task in ipairs(tasks) do
	--	--
	--	local num,_, desc = task:match("^(%d+)%s(?:%(%S%)%s+)?(.+)$")
	--	if desc == line then
	--		id = num
	--		break
	--	end
	--end

	print("Marked todo as done! (just deleted)")
	vim.cmd("normal! dd")
end

-- Util: remove empty lines
local function strip_blank_lines(lines)
	local cleaned = {}
	for _, line in ipairs(lines) do
		if line:match("%S") then
			table.insert(cleaned, line)
		end
	end
	return cleaned
end

-- Grouped sort logic
local function grouped_sort(key_fn)
	if not is_todo_file() then return end
	local lines = strip_blank_lines(vim.api.nvim_buf_get_lines(0, 0, -1, false))
	local buckets = {}

	for _, line in ipairs(lines) do
		local key = key_fn(line)
		if not buckets[key] then
			buckets[key] = {}
		end
		table.insert(buckets[key], line)
	end

	local sorted_keys = {}
	for key in pairs(buckets) do table.insert(sorted_keys, key) end
	table.sort(sorted_keys)

	local final_lines = {}
	for _, key in ipairs(sorted_keys) do
		for _, line in ipairs(buckets[key]) do
			table.insert(final_lines, line)
		end
		table.insert(final_lines, "") -- add blank line after group
	end

	-- Remove final blank line if it exists
	if final_lines[#final_lines] == "" then
		table.remove(final_lines)
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, final_lines)
end

-- Key extractors
local function get_priority_key(line)
	local p = line:match("^%((%u)%)")
	return p and p or "~" -- tilde = sorts after all letters
end

local function get_context_key(line)
	local c = line:match("@(%w+)")
	return c and c or "~"
end

local function get_project_key(line)
	local p = line:match("%+(%w+)")
	return p and p or "~"
end

-- Sorters
function M.sort_by_priority()
	grouped_sort(get_priority_key)
end

function M.sort_by_context()
	grouped_sort(get_context_key)
end

function M.sort_by_project()
	grouped_sort(get_project_key)
end

function M.setup()
	local opts = { noremap = true, silent = true }

	for i = string.byte("a"), string.byte("z") do
		local letter = string.char(i)
		vim.keymap.set("n", "<leader>p" .. letter, function() M.set_priority(letter) end, opts)
	end

	vim.keymap.set("n", "<leader>p<leader>", M.remove_priority, opts)

	vim.keymap.set("n", "<leader>sp", M.sort_by_priority, opts)
	vim.keymap.set("n", "<leader>sc", M.sort_by_context, opts)
	vim.keymap.set("n", "<leader>sr", M.sort_by_project, opts)

	-- New keymap for marking todo as done
	vim.keymap.set("n", "<leader>td", M.mark_done, opts)
end

return M
