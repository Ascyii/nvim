-- Custom keymaps

require("utils.functions")

local conf = require("conf")

-------------------------------------------------------
--------------------- KEYMAPS -------------------------
-------------------------------------------------------

-- Fast window switch
vim.keymap.set("n", "<leader>w", "<C-w>w")

vim.keymap.set('n', '<leader>zq', ':e ~/synced/brainstore/zettelkasten/input.txt<CR>`.zz')
vim.keymap.set("n", "<leader>me", ":mes<CR>")

vim.keymap.set("n", "<leader>snt", "<cmd>set nu<CR>")
vim.keymap.set("n", "<leader>snf", "<cmd>set nonu<CR>")

vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { silent = true })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set('n', '<leader>a', 'm9ggVG"+y`9')
vim.keymap.set('n', '<leader>va', 'ggVG')
vim.keymap.set('n', '<leader>tr', ':tabnew<CR>:term<CR>i')

-- Indent all will be replaced by the formatting of lsp where the lsp is installed
vim.keymap.set('n', '<leader>ia', 'gg=G<C-o>zz')
vim.keymap.set('n', '<leader>ya', 'ggVG"+y<C-o>')
vim.keymap.set('n', '<leader>ss', ':wa<CR>')
vim.keymap.set("n", "<leader>nn", ":e ~/synced/brainstore/zettelkasten/quick<CR>", { silent = true })

-- Folding
local opts = { noremap = true, silent = true }
local is_all_folded = false
local function toggle_fold()
	if is_all_folded then
		vim.opt.foldlevel = 99
	else
		vim.opt.foldlevel = 0
	end
	is_all_folded = not is_all_folded
end
vim.api.nvim_set_keymap("n", "<leader>ft", "za", opts)      -- toggle fold under cursor
vim.keymap.set("n", "<leader>fs", toggle_fold, opts)  -- close all folds

-- Quickly open some buffers
vim.keymap.set('n', '<leader>occ', ':e ~/.config/nvim/init.lua<CR>`.zz')
vim.keymap.set('n', '<leader>oct', ':e ~/synced/vault/contacts/contacts.txt<CR>`.zz')
vim.keymap.set('n', '<leader>ock', ':e ~/.config/nvim/lua/config/keymaps.lua<CR>`.zz')
vim.keymap.set('n', '<leader>ocd', ':e ~/.config/nvim/lua/config/autocmds.lua<CR>`.zz')
vim.keymap.set('n', '<leader>oco', ':e ~/.config/nvim/lua/config/options.lua<CR>`.zz')
vim.keymap.set('n', '<leader>ocl', ':e ~/.config/nvim/lua/config/lazy.lua<CR>`.zz')
vim.keymap.set('n', '<leader>oczl', ':e ~/.config/nvim/lua/config/lsp.lua<CR>`.zz')
vim.keymap.set('n', '<leader>ocp', ':e ~/.config/nvim/lua/plugins/misc.lua<CR>`.zz')
vim.keymap.set('n', '<leader>ocf', ':e ~/.config/nvim/lua/utils/functions.lua<CR>`.zz')
vim.keymap.set('n', '<leader>oca', ':e ~/.config/nvim/lua/utils/after.lua<CR>`.zz')
vim.keymap.set('n', '<leader>oq', ':e ~/synced/brainstore/input.txt<CR>`.zz')
vim.keymap.set('n', '<leader>ot', ':e ~/synced/brainstore/todos/todo.txt<CR>`.zz')
vim.keymap.set('n', '<leader>od', ':e ~/synced/brainstore/todos/done.txt<CR>`.zz')
vim.keymap.set('n', '<leader>ou', ':e ~/projects/university/' .. conf.season .. '/input.txt<CR>`.zz')
vim.keymap.set('n', '<leader>oz', ':e ~/.zshrc<CR>`.zz')
vim.keymap.set('n', '<leader>oaa', ':e ~/.common_shell<CR>`.zz')
vim.keymap.set('n', '<leader>ow', ':e ~/synced/brainstore/waste.txt<CR>')

vim.keymap.set('n', '<leader>ohh', ':e ~/nixos/user/home.nix<CR>`.zz')
vim.keymap.set('n', '<leader>op', ':e ~/nixos/user/packages.nix<CR>`.zz')
vim.keymap.set('n', '<leader>on', ':e ~/nixos/configuration.nix<CR>`.zz')
vim.keymap.set('n', '<leader>om', ':e ~/nixos/modules/<CR>')
vim.keymap.set('n', '<leader>oho', ':e ~/nixos/hosts<CR>')

vim.keymap.set('n', '<leader>ll', ':Lazy<CR>')

vim.keymap.set('n', '<leader>sw', function()

	local word = vim.fn.expand("<cword>")
	local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
	if replacement ~= "" then
		vim.cmd(string.format("%%s/\\<%s\\>/%s/gI", vim.fn.escape(word, '\\/'), vim.fn.escape(replacement, '\\/')))
	end
end, { desc = "Substitute word under cursor (prompt)" })

-- Substitution in visual mode
vim.keymap.set('v', '<leader>sv', function()
	-- Save the current selection
	local save_reg = vim.fn.getreg('"')
	local save_regtype = vim.fn.getregtype('"')

	-- Yank the visual selection into the " register
	vim.cmd('normal! ""y')

	local selection = vim.fn.getreg('"')
	-- Escape magic characters for the search
	selection = vim.fn.escape(selection, '\\/.*$^~[]')

	-- Prompt for the replacement text
	local replacement = vim.fn.input("Replace '" .. selection .. "' with: ")
	if replacement ~= "" then
		vim.cmd(string.format("%%s/%s/%s/gI", selection, replacement))
	end

	-- Restore previous register
	vim.fn.setreg('"', save_reg, save_regtype)
end, { desc = "Substitute selection in file" })

vim.keymap.set('n', '<leader>pp', function()
	vim.api.nvim_command('normal! "+p')
end, { desc = 'Paste from system clipboard' })
vim.keymap.set('v', '<leader>p', function()
	vim.cmd('normal! "+p')
end, { desc = 'Yank to clipboard and keep the selection' })

vim.keymap.set('v', 'p', function()
	local unnamed_content = vim.fn.getreg('""')
	vim.api.nvim_command('normal! p')
	vim.fn.setreg('""', unnamed_content)
end, { desc = 'Paste from unnamed register (don\'t overwrite it) in visual mode' })

vim.keymap.set('v', '<leader>y', function()
	vim.cmd('normal! "+y')
	vim.cmd('normal! gv')
end, { desc = 'Yank to clipboard and keep the selection' })

vim.keymap.set('i', '<C-k>', function()
	local col = vim.fn.col('.')
	local line = vim.fn.line('.')
	local line_len = vim.fn.col('$') - 1
	if col <= line_len then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, false, true), 'n', true)
	else
		if line < vim.fn.line('$') then
			vim.cmd('normal! j^')
		end
	end
end)

-- Move left with wrapping
vim.keymap.set('i', '<C-j>', function()
	local col = vim.fn.col('.')
	local line = vim.fn.line('.')
	if col > vim.fn.indent(line) + 1 then
		-- not at very beginning (after indent), move left
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left>', true, false, true), 'n', true)
	else
		if line > 1 then
			vim.cmd('normal! k$')
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, false, true), 'n', true)
		end
	end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>or",
	function()
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
	, { noremap = true, silent = true })

-- Fast quitter
vim.keymap.set('n', '<leader>q', function()
	pcall(function()
		vim.cmd('wa')
	end)
	vim.cmd('qa!')
end)

-- This needs to be refined for quick access to a new file or a recently edited one
vim.keymap.set('n', '<leader>ov',
	function()
		require('telescope.builtin').find_files({
			prompt_title = "Select lecture in " .. conf.season,
			cwd = conf.uni_dir,
			find_command = {
				"eza", "-1", "-D"
			}
		})
	end
)

vim.keymap.set("n", "<leader>r",
	function()
		local current_file = vim.fn.expand('%:p:h') -- get directory of current file
		local cmd = 'git -C ' .. vim.fn.fnameescape(current_file) .. ' status'
		vim.fn.system(cmd)
		if vim.v.shell_error == 0 then
			local git_root = vim.fn.systemlist('git -C ' ..
				vim.fn.fnameescape(current_file) .. ' rev-parse --show-toplevel')
			[1]
			vim.cmd('cd ' .. vim.fn.fnameescape(git_root))
		else
			vim.cmd('cd ' .. vim.fn.fnameescape(current_file))
		end
	end
)

vim.keymap.set('n', '<leader>ok', function()
	local current_date = os.date("%Y-%m-%d")
	local week_number = os.date("%V")
	local day_of_week = os.date("%a")
	local path = "~/storage/notes/calendar/calendar_" .. os.date("%Y") .. ".txt"
	local keys = ":e " ..
	path .. "<CR>/" .. current_date .. " w" .. tonumber(week_number) .. " " .. day_of_week .. "<CR>$"
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end)
