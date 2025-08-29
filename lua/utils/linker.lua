local M = {}

local brainstore_dir = "~/synced/brainstore"
local projects_dir = "~/projects"
local mail_dir = "~/mail/plain_emails"
local contacts_file = "~/synced/vault/contacts/contacts.txt"
local cal_dir = "~/synced/brainstore/calendar"

local function fzf_select(options, prompt, callback)
	local fzf = require("fzf-lua")
	fzf.fzf_exec(options, {
		prompt = prompt .. "> ",
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					callback(selected[1])
				end
			end,
		},
	})
end

function M.insert_brainstore_link()
	require('telescope.builtin').find_files({
		hidden = true,
		no_ignore = true,
		follow = true,
		prompt_title = "Things in Brain",
		cwd = vim.fn.expand(brainstore_dir),
		find_command = {
			"rg", "--files",
			"--hidden",
			"--glob", "!**/.git/*",
			"--glob", "!**/*.{jpg,png,gif,mp4,mkv,tar,zip,iso}",
		},
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')

			local function insert_link()
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end
				local selected = selection.path or selection.filename or selection[1]
				if selected then
					actions.close(prompt_bufnr)
					local link = "[[brain:" .. selected:gsub(vim.fn.expand(brainstore_dir) .. "/", "") .. "]]"
					vim.cmd("normal! h")
					vim.api.nvim_put({ link }, "c", true, true)
				end
			end

			map('i', '<CR>', insert_link)
			map('n', '<CR>', insert_link)

			return true
		end
	})
end

function M.insert_mail_link()
	vim.fn.system("python " .. vim.fn.expand("~/projects/scripts/extract_mail.py"))
	vim.fn.system("find " .. mail_dir .. " -type f > /tmp/mail_files")
	local mails = vim.fn.readfile("/tmp/mail_files")

	fzf_select(mails, "Mails", function(selected)
		local link = "[[mail:" .. selected:gsub(vim.fn.expand(mail_dir) .. "/", "") .. "]]"
		vim.api.nvim_put({ link }, "c", true, true)
	end)
end

function M.insert_contact_link()
	local contacts = vim.fn.readfile(vim.fn.expand(contacts_file))

	fzf_select(contacts, "Contacts", function(selected)
		local name = selected:match("^(.-)%s") or selected -- get first word as contact name
		local link = "[[contact:" .. name .. "]]"
		vim.api.nvim_put({ link }, "c", true, true)
	end)
end

function M.insert_date_link()
	local year = os.date("%y")
	local text = string.format("[[date:.%s]]", year)

	vim.api.nvim_put({ text }, "c", true, true)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_win_set_cursor(0, { row, col - 4 })
	vim.cmd("startinsert")
end

function M.insert_project_link()
	require('telescope.builtin').find_files({
		hidden = true,
		no_ignore = true,
		disable_devicons = true,
		follow = true,
		prompt_title = "List of projects",
		cwd = vim.fn.expand(projects_dir),
		find_command = {
			"eza", "-1", "-D",
		},
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')

			local function insert_link()
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end
				local selected = selection.path or selection.filename or selection[1]
				if selected then
					actions.close(prompt_bufnr)
					local project = selected:gsub(vim.fn.expand(projects_dir) .. "/", "")


					require('telescope.builtin').find_files({
						hidden = true,
						no_ignore = true,
						follow = true,
						disable_devicons = true,
						prompt_title = "Pick a file. Press <ESC> to link just " .. project .. ".",
						cwd = vim.fn.expand(selected),
						find_command = {
							"rg", "--files",
							"--hidden",
							"--glob", "!**/.git/*",
						},
						attach_mappings = function(prompt_bufnr, map)
							local actions = require('telescope.actions')
							local action_state = require('telescope.actions.state')

							local function insert_link()
								local selection = action_state.get_selected_entry()
								if not selection then
									return
								end
								local selected = selection.path or selection.filename or selection[1]
								if selected then
									actions.close(prompt_bufnr)
									local link = "[[project:" ..
									selected:gsub(vim.fn.expand(projects_dir) .. "/", "") .. "]]"
									vim.api.nvim_put({ link }, "c", true, true)
								end
							end

							local function insert_link_top()
								actions.close(prompt_bufnr)
								local link = "[[project:" .. project .. "]]"
								vim.api.nvim_put({ link }, "c", true, true)
							end

							map('i', '<CR>', insert_link)
							map('n', '<CR>', insert_link)

							map('i', '<ESC>', insert_link_top)
							map('n', '<ESC>', insert_link_top)


							return true
						end
					})
				end
			end

			map('i', '<CR>', insert_link)
			map('n', '<CR>', insert_link)

			return true
		end
	})
end

local function spliting(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function pad2(n)
	n = tonumber(n)
	if n < 10 then
		return "0" .. n
	else
		return tostring(n)
	end
end

-- The heart of this project following
-- Remember to go back with C-O
function M.follow_link()
	local line = vim.api.nvim_get_current_line()
	local link = line:match("%[%[(.-)%]%]")
	if not link then
		print("No link found on this line.")
		return
	end

	local kind, target = link:match("^(.-):(.*)$")
	if not kind or not target then
		print("Invalid link format.")
		return
	end


	-- List of all kinds that are available
	-- Here brainstore and projects are kind of the same but I keep them separated
	if kind == "brain" then
		vim.cmd("edit " .. brainstore_dir .. "/" .. target)
	elseif kind == "mail" then
		vim.cmd("edit " .. mail_dir .. "/" .. target)
	elseif kind == "contact" then
		vim.cmd("vsplit " .. contacts_file)
		vim.cmd("/" .. target)
	elseif kind == "project" then
		vim.cmd("edit " .. projects_dir .. "/" .. target)
	elseif kind == "date" then
		-- target: "4.3.25" or "03.04.2034"
		local splits = spliting(target, '.')
		local day = pad2(splits[1])
		local month = pad2(splits[2])
		local year = splits[3]

		if #year == 4 then
			year = year:sub(3, 4)
		end

		vim.cmd("edit " .. cal_dir .. "/calendar_20" .. year .. ".txt")
		vim.cmd("/" .. "20" .. year .. "-" .. month .. "-" .. day)
		vim.cmd("normal! zz")
	else
		print("Unknown link type: " .. kind .. ". Must be one of: " .. "mail, contact, project, brain, date.")
	end
end

return M
