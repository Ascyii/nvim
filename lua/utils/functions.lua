-- General helper functions
local M = {}

function M.Sleep(n)
	os.execute("sleep " .. tonumber(n))
end

function open_vorlesung()
	local mapss = require("config.keymaps")
	-- get globals
	set_obs()
	local uni_dir = vim.fn.expand("~/projects/university/" .. _G.season)

	require('telescope.builtin').find_files {
		prompt_title = "Select Vorlesung in " .. _G.season,
		cwd = uni_dir,
		find_command = {
			"eza", "-1", "-D"
		},
	}
end



function find_eff()
	require('telescope.builtin').find_files({
		hidden = true, -- show hidden files (dotfiles)
		no_ignore = true, -- respect .gitignore (ignore files listed in .gitignore)
		follow = true, -- follow symlinks
		disable_devicons = true,

		-- Additional filtering to exclude .git, .cache, .local, and large files
		prompt_title = "Find Files - custom",
		find_command = {
			"rg", "--files",
			"--glob", "!**/.git/*",
			"--glob", "!**/.cache/*",
			"--glob", "!**/.local/*",
			"--glob", "!**/bigfiles/*",                -- exclude large files folder
			"--glob", "!**/*.{jpg,png,gif,mp4,mkv,tar,zip,iso}" -- exclude some large file types
		}
	})
end

-- TODO: implement this
--function search_brain_links()
--  local fzf = require('fzf')
--  local cmd = "grep -oP '\\[\\[.*:' " .. vim.fn.expand('%')  -- grep pattern to search for [[.*:
--  fzf.fzf(cmd, {
--    preview = "bat --style=numbers --color=always --line-range :500",  -- preview with bat (optional)
--    sink = function(selected)
--      if selected and #selected > 0 then
--        local line = vim.fn.search(selected[1], 'n')  -- jump to the match
--        if line > 0 then
--          vim.api.nvim_win_set_cursor(0, {line, 0})
--        end
--      end
--    end
--  })
--end


function set_root()
	local current_file = vim.fn.expand('%:p:h') -- get directory of current file
	local cmd = 'git -C ' .. vim.fn.fnameescape(current_file) .. ' status'
	vim.fn.system(cmd)
	if vim.v.shell_error == 0 then
		local git_root = vim.fn.systemlist('git -C ' .. vim.fn.fnameescape(current_file) .. ' rev-parse --show-toplevel')
			[1]
		vim.cmd('cd ' .. vim.fn.fnameescape(git_root))
	else
		vim.cmd('cd ' .. vim.fn.fnameescape(current_file))
	end
end

-- Function to open the last file
function open_last_file()
	local last_file_path = vim.fn.stdpath('data') .. "/lastfile.txt"
	local file = io.open(last_file_path, "r")
	if file then
		local last_file = file:read("*line")
		file:close()
		if last_file and vim.fn.filereadable(last_file) == 1 then
			vim.cmd("edit " .. last_file)
			pcall(function()
				vim.cmd('normal! `.') -- Go to the last edit position
				vim.cmd('normal! zz') -- Center the cursor on the screen
			end)
		else
			print("Last file does not exist or is not readable")
		end
	else
		print("No last file found")
	end
end


return M
