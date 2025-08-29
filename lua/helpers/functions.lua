-- General helper functions

function sleep(n)
	os.execute("sleep " .. tonumber(n))
end


-- branching depeding on diff mode
if vim.g.diffm then
	-- diffmode
else
	-- Function to open NvimTree based on current file or Git root
	local api = require("nvim-tree.api")
	function open_tree_based_on_file()
		local file_path = vim.fn.expand("%:p")
		local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
		local dir = vim.fn.filereadable(file_path) and vim.fn.fnamemodify(file_path, ":p:h") or ""

		-- If inside a Git repo, use the Git root as the base directory
		local open_dir = git_root ~= "" and git_root or dir

		-- Open NvimTree in that directory
		api.tree.open({ path = open_dir })
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

	-- TODO: fix not putting the pdf in another dir then the current workdir
	-- 		 when in a uni folder
	-- Open and watch typst
	local watch_job_id = nil
	local watch_buf_id = nil
	function watch_and_open()
		local input = vim.fn.expand("%:p")
		if not input:match("%.typ$") then
			vim.notify("Not a Typst file", vim.log.levels.WARN)
			return
		end

		local dir = vim.fn.fnamemodify(input, ":h")        -- directory of the Typst file
		local filename = vim.fn.expand("%:t:r") .. ".pdf"  -- filename without extension + .pdf

		-- Get the underlying unicourse dir
		local one_up = vim.fn.fnamemodify(dir, ":h")

		print(one_up)
		local pdf_dir = nil
		if vim.fn.filereadable(one_up .. "/.unicourse") == 1 then
			pdf_dir = one_up .. "/../../pdfs"
		else
			pdf_dir = dir
		end

		vim.fn.mkdir(pdf_dir, "p")
		local output = pdf_dir .. "/" .. filename

		-- Check if a watcher is already running for this file
		if watch_job_id then
			vim.notify("Typst watcher already running - please close zathura", vim.log.levels.INFO)
			return
		end



		-- Start typst watch
		local cwd = vim.fn.getcwd() -- set the starting directory
		-- TODO: root setting does not work
		local watch_cmd = { "typst", "watch", "--root", cwd, input, output }
		watch_job_id = vim.fn.jobstart(watch_cmd, {
			stdout_buffered = false,
			stderr_buffered = false,  -- Ensure stderr is unbuffered for real-time error output
			on_stderr = function(_, data)
				if data then
					if not watch_tab_id then
						pre_tab = vim.api.nvim_get_current_tabpage()  -- Get the current tab ID
						vim.cmd('tabnew')  -- Open a new tab
						watch_tab_id = vim.api.nvim_get_current_tabpage()  -- Get the current tab ID
						watch_buf_id = vim.api.nvim_get_current_buf()  -- Get the buffer ID of the new tab
						vim.api.nvim_buf_set_option(watch_buf_id, "swapfile", false)
						vim.api.nvim_buf_set_name(watch_buf_id, "/tmp/TypstLog")
						vim.api.nvim_buf_set_lines(watch_buf_id, 0, 0, false, { "Watching: " .. input })  -- Insert at the top
						vim.cmd('write!')
						vim.api.nvim_set_current_tabpage(pre_tab)
					end
					-- Write stdout data to the same buffer
					for _, line in ipairs(data) do
						if line ~= "" then
							vim.api.nvim_buf_set_lines(watch_buf_id, -1, -1, false, { "[LOG] " .. line })
						end
					end
				end
			end,
			on_exit = function(_, exit_code)
				-- Ensure to close the tab that holds the logs
				--if watch_tab_id then
				--	-- Switch to the tab holding the log buffer and close it
				--	vim.api.nvim_set_current_tabpage(watch_tab_id)
				--	vim.cmd('tabclose')  -- Close the tab holding the log buffer
				--end
				if exit_code == 0 then
					vim.notify("Typst watch stopped successfully", vim.log.levels.INFO)
				else
					vim.notify("Typst watch stopped with errors", vim.log.levels.ERROR)
				end
				watch_job_id = nil
			end,
		})
		vim.notify("Started Typst watch", vim.log.levels.INFO)

		-- Start sioyek with the --new-window flag and stop watch when it exits
		-- ensure that there is no sioyek
		vim.fn.system("killall .zathura-wrapped")
		sleep(0.5)
		vim.fn.jobstart({ "zathura", output }, {
			on_exit = function()
				if watch_job_id then
					vim.fn.jobstop(watch_job_id)
				end
				watch_job_id = nil
			end,
		})
	end

end


function find_eff()
	require('telescope.builtin').find_files({
		hidden = true,       -- show hidden files (dotfiles)
		no_ignore = true,    -- respect .gitignore (ignore files listed in .gitignore)
		follow = true,       -- follow symlinks
		disable_devicons = true,

		-- Additional filtering to exclude .git, .cache, .local, and large files
		prompt_title = "Find Files - custom",
		find_command = {
			"rg", "--files", 
			"--glob", "!**/.git/*", 
			"--glob", "!**/.cache/*", 
			"--glob", "!**/.local/*", 
			"--glob", "!**/bigfiles/*",  -- exclude large files folder
			"--glob", "!**/*.{jpg,png,gif,mp4,mkv,tar,zip,iso}"  -- exclude some large file types
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
		local git_root = vim.fn.systemlist('git -C ' .. vim.fn.fnameescape(current_file) .. ' rev-parse --show-toplevel')[1]
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
			local success, _ = pcall(function()
				vim.cmd('normal! `.')  -- Go to the last edit position
				vim.cmd('normal! zz')  -- Center the cursor on the screen
			end)
		else
			print("Last file does not exist or is not readable")
		end
	else
		print("No last file found")
	end
end

