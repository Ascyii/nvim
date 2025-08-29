local M = {}

local functions = require("utils.functions")

local watch_job_id = nil
local watch_buf_id = nil
local watch_tab_id = nil

function M.Watch_and_open()
	-- Parse the current file and check for typst
	vim.notify("INIT", vim.log.levels.WARN)
	local input = vim.fn.expand("%:p")
	if not input:match("%.typ$") then
		vim.notify("Not a Typst file", vim.log.levels.WARN)
		return
	end
	local dir = vim.fn.fnamemodify(input, ":h")    -- directory of the Typst file
	local filename = vim.fn.expand("%:t:r") .. ".pdf" -- filename without extension + .pdf

	-- Check if a watcher is already running for this file
	if watch_job_id then
		vim.notify("Typst watcher already running - please close zathura", vim.log.levels.INFO)
		return
	end

	local output = dir .. "/" .. filename

	-- Start typst watch
	local cwd = vim.fn.getcwd() -- set the starting directory

	-- TODO: root setting does not work
	local watch_cmd = { "typst", "watch", "--root", cwd, input, output }
	watch_job_id = vim.fn.jobstart(watch_cmd, {
		stdout_buffered = false,
		stderr_buffered = false, -- Ensure stderr is unbuffered for real-time error output
		on_stderr = function(_, data)
			if data then
				if not watch_tab_id then
					local pre_tab = vim.api.nvim_get_current_tabpage() -- Get the current tab ID
					vim.cmd('tabnew')                  -- Open a new tab
					watch_tab_id = vim.api.nvim_get_current_tabpage() -- Get the current tab ID
					watch_buf_id = vim.api.nvim_get_current_buf() -- Get the buffer ID of the new tab
					vim.api.nvim_buf_set_option(watch_buf_id, "swapfile", false)
					vim.api.nvim_buf_set_name(watch_buf_id, "/tmp/TypstLog")
					vim.api.nvim_buf_set_lines(watch_buf_id, 0, 0, false, { "Watching: " .. input }) -- Insert at the top
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
			if exit_code == 0 then
				vim.notify("Typst watch stopped successfully", vim.log.levels.INFO)
			else
				vim.notify("Typst watch stopped with errors", vim.log.levels.ERROR)
			end
			watch_job_id = nil
		end,
	})
	vim.notify("Started Typst watch", vim.log.levels.INFO)

	vim.fn.system("killall .zathura-wrapped")
	functions.Sleep(0.5)
	vim.fn.jobstart({ "zathura", output }, {
		on_exit = function()
			if watch_job_id then
				vim.fn.jobstop(watch_job_id)
			end
			watch_job_id = nil
		end,
	})
end

return M
