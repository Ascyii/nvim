local M = {}

local fzf = require("fzf-lua")
local fn = vim.fn
local conf = require("conf")

-- Function to scan for .unicourse files and get their course directories
function M.get_course_directories()
	local dirs = {}
	local function scan_dir(dir)
		for _, entry in ipairs(fn.glob(dir .. "/*", true, true)) do
			if fn.isdirectory(entry) == 1 then
				local unicourse_file = entry .. "/.unicourse"
				if fn.filereadable(unicourse_file) == 1 then
					local course_info = {}
					for line in io.lines(unicourse_file) do
						if line:match("^name: ") then
							course_info.name = line:sub(7)
						elseif line:match("^short: ") then
							course_info.short = line:sub(8)
						end
					end
					if course_info.name and course_info.short then
						table.insert(dirs, { name = course_info.name, short = course_info.short, path = entry })
					end
				end
			end
		end
	end

	scan_dir("~/projects/university/" .. conf.season)
	return dirs
end

-- Function to show the fzf menu for selecting a course directory
function M.select_course_directory()
	local courses = M.get_course_directories()
	local course_names = {}

	for _, course in ipairs(courses) do
		table.insert(course_names, course.name .. " (" .. course.short .. ")")
	end

	fzf.fzf_exec(course_names, {
		prompt = "Select a course > ",
		actions = {
			["default"] = function(selected)
				for _, course in ipairs(courses) do
					if selected[1] == (course.name .. " (" .. course.short .. ")") then
						M.show_course_menu(course)
						break
					end
				end
			end,
		},
	})
end

-- Function to show the fzf menu for actions on a selected course folder
function M.show_course_menu(course)
	local files = {}
	-- Collect all VL files in the Vorlesungen directory
	for _, file in ipairs(fn.glob(course.path .. "/VL/*", true, true)) do
		if file:match("%.typ$") then
			table.insert(files, file)
		end
	end

	-- Collect options
	-- TODO: implement zettel (Hausaufgaben) management
	-- For example creation of new ones and quick opening of the pdfs
	local options = {
		"Open the newest VL file",
		"Create a new VL",
		"Open the course folder",
		"Open a specific file",
	}

	fzf.fzf_exec(options, {
		prompt = "Choose an action > ",
		actions = {
			["default"] = function(selected)
				if selected[1] == "Open the newest VL file" then
					local newest_file = M.get_newest_vl_file(files)
					vim.cmd("edit " .. newest_file)
				elseif selected[1] == "Create a new VL" then
					M.create_new_vl(course)
				elseif selected[1] == "Open the course folder" then
					vim.cmd("edit " .. course.path)
				elseif selected[1] == "Open a specific file" then
					fzf.fzf_exec(fn.glob(course.path .. "/*", true, true), {
						prompt = "Pick a file to open > ",
						actions = {
							["default"] = function(file)
								vim.cmd("edit " .. file[1])
							end,
						},
					})
				end
			end,
		},
	})
end

-- Function to get the newest VL file based on modification time
function M.get_newest_vl_file(files)
	local newest_file = nil
	local newest_time = 0
	for _, file in ipairs(files) do
		local stat = fn.getftime(file)
		if stat > newest_time then
			newest_time = stat
			newest_file = file
		end
	end
	return newest_file
end

-- Function to insert chapter reference at top summary section
local function add_chapter_to_summary(course, new_vl_name)
	local book_file = vim.fn.expand(conf.book_file)
	local rel_path = string.format("%s/VL/%s", course.path:match("university/(.+)$"), new_vl_name)
	local default_title = new_vl_name
	local chapter_line = string.format('        - #chapter("%s")[%s]\n', rel_path, default_title:match("^(.-)%."))

	local lines = {}
	for l in io.lines(book_file) do
		table.insert(lines, l)
	end

	local out = io.open(book_file, "w")
	local inserted = false
	local right_block = false
	for _, l in ipairs(lines) do
		-- insert after the course's existing index line
		if not inserted and l:match('"' .. course.path:match("university/(.+)$") .. '/index.typ"') then
			right_block = true
		end
		if not inserted and right_block and l:match("^%s*$") then
			out:write(chapter_line .. "\n" .. l)
			inserted = true
		else
			out:write(l .. "\n")
		end
	end
	out:close()
end

-- Function to create a new VL file based on the template and incrementing the number
function M.create_new_vl(course)
	local vl_dir = course.path .. "/VL"
	pcall(function()
		vim.fn.mkdir(vl_dir)
	end)
	-- Hard coded this
	local template_path = vim.fn.expand("~/projects/university/data/template.typ")
	if fn.filereadable(template_path) == 1 then
		-- Find the latest VL number in the folder
		--- @type number?
		local latest_num = 0
		for _, file in ipairs(fn.glob(vl_dir .. "/*", true, true)) do
			if file:match(course.short .. "VL(%d+).typ$") then
				--- @type number?
				local num = tonumber(file:match(course.short .. "VL(%d+).typ$"))
				if num > latest_num then
					latest_num = num
				end
			end
		end

		-- Create new VL file with incremented number
		local new_vl_name = string.format("%sVL%d.typ", course.short, latest_num + 1)
		local new_vl_path = vl_dir .. "/" .. new_vl_name

		-- Copy the template if it exists
		vim.fn.system({ "cp", template_path, new_vl_path })

		add_chapter_to_summary(course, new_vl_name)

		-- Open the new VL file
		vim.cmd("edit " .. new_vl_path)
	else
		print("Template file (template.typ) not found!")
	end
end

return M
