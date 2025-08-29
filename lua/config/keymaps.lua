-- ###########################
-- the heart of neovim #######
-- ###########################

require("helpers.functions")

-- gloabal settings
vim.keymap.set('n', '<leader>q', function()
	local success, _ = pcall(function()
		vim.cmd('wa')  -- Write (save) all buffers
	end)
	vim.cmd('qa!')  -- Quit all buffers forcefully
end)

vim.keymap.set("n", "<leader>w", "<C-w>w")

vim.keymap.set('v', '<leader>p', function()
	vim.cmd('normal! "+p')
end, { desc = 'Yank to clipboard and keep the selection' })

-- branching depeding on diff mode
if vim.g.diffm then
	-- diff view commands
	vim.keymap.set('n', '<leader>do', ":DiffviewClose<CR>:DiffviewOpen<CR>")
	vim.keymap.set('n', '<leader>df', ":DiffviewClose<CR>:DiffviewFileHistory<CR>")
	vim.keymap.set('n', '<leader>dt', ":DiffviewToggleFiles<CR>")
	vim.keymap.set('n', '<leader>dc', ":DiffviewClose<CR>")
	vim.keymap.set('n', '<leader>dl', ":DiffviewLog<CR>")

	-- vim.keymap.set("n", "<leader>e", "<C-w>w<C-w>w")
else
	-- not in diff mode
	-- TODO: make this dynamic
	local season = "S2"

	local links = require("helpers.linker") -- replace with real file path
	local user = vim.fn.system('whoami'):gsub('\n', '')
	local api = require("nvim-tree.api")
	local builtin = require('telescope.builtin')
	local current_date = os.date("%Y-%m-%d")
	local week_number = os.date("%W") + 1  -- Week number (starting from Sunday)
	local day_of_week = os.date("%a")  -- Abbreviated weekday name (e.g., Mon, Tue)

	-- this is how to access global vars
	function set_obs()
		-- _G is the global table. this creates variable 'obs' attached to
		-- the global table with the value 'some text value'
		_G.season = season
	end


	--------------------- NORMAL -------------------------
	

	-- vim.keymap.set("i", "<Tab>", "<C-p>", { silent = true })


	vim.keymap.set("n", "L", ":BufferNext<CR>", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "n", "nzz", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "N", "Nzz", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "H", ":BufferPrevious<CR>", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "<C-o>", "<C-o>zz", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "<C-i>", "<C-i>zz", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true }) -- also update the root with the bang

	vim.keymap.set('n', '<leader>a', 'm9ggVG"+y`9')
	vim.keymap.set('n', '<leader>va', 'ggVG')

	-- Launch panel if nothing is typed after <leader>z
	vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

	-- Most used functions
	vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
	vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
	vim.keymap.set('n', '<leader>zq', ':e ~/synced/brainstore/zettelkasten/input.txt<CR>`.zz')
	vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
	vim.keymap.set("n", "<leader>zr", "<cmd>Telekasten rename_note<CR>")
	vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
	vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
	vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
	vim.keymap.set("n", "<leader>zw", "<cmd>Telekasten find_weekly_notes<CR>")
	vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

	vim.keymap.set("n", "<leader>me", ":mes<CR>")
	vim.keymap.set("n", "<C-/>", ":ToggleTerm<CR>")
	vim.keymap.set("t", "<C-/>", "<C-\\><C-n>:ToggleTerm<CR>")

	vim.keymap.set("n", "<leader>snt", "<cmd>set nu<CR>")
	vim.keymap.set("n", "<leader>snf", "<cmd>set nonu<CR>")


	-- Call insert link automatically when we start typing a link
	vim.keymap.set("n", "<leader>il", "<cmd>Telekasten insert_link<CR>")

	require("custom.uni")
	vim.keymap.set("n", "<leader>nv", function()

		select_course_directory()
		--pick_unicourse("/home/jonas/projects/university/S2")  -- Change path accordingly
	end, { desc = "Open UniCourse menu" })


	vim.keymap.set('n', '<leader>ca', 'ggVGd')
	vim.keymap.set("n", "<leader>bd", ":BufferDelete<CR>", { silent = true }) -- also update the root with the bang

	-- Typstar stuff
	vim.keymap.set("n", "<leader>ti", ":TypstarInsertRnote<CR>", { silent = true }) -- also update the root with the bang
	vim.keymap.set("n", "<leader>to", ":TypstarOpenDrawing<CR>", { silent = true }) -- also update the root with the bang


	-- Get a ready to use terminal
	vim.keymap.set('n', '<leader>tr', ':tabnew<CR>:term<CR>i')
	vim.keymap.set("n", "<leader>tt", ":Telescope<CR>", { desc = "Follow Link" })
	vim.keymap.set('n', '<leader>tw', watch_and_open, { noremap = true, silent = true })

	-- This needs to be refined for quick access to a new file or a recently edited one
	vim.keymap.set('n', '<leader>ov', open_vorlesung)
	-- new quick note file
	-- TODO: make this smarter
	vim.keymap.set("n", "<leader>nn", ":e ~/synced/brainstore/zettelkasten/quick<CR>", { silent = true }) -- also update the root with the bang

	vim.keymap.set("n", "<leader>r", set_root)

	-- Custom journal plugin disable temporary
	-- local journal = require("custom.journal")
	-- vim.keymap.set("n", "<leader>jt", journal.open_today, { desc = "Open Today's Journal" })
	-- vim.keymap.set("n", "<leader>ja", journal.list_all_journals, { desc = "Open Today's Journal" })
	-- vim.keymap.set("n", "<leader>jm", journal.search_this_month, { desc = "Search This Month's Journals" })

	-- Quickly open some buffers
	-- Open all the vim configs instant
	vim.keymap.set('n', '<leader>occ', ':e ~/.config/nvim/init.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>oct', ':e ~/synced/vault/contacts/contacts.txt<CR>`.zz')
	vim.keymap.set('n', '<leader>ock', ':e ~/.config/nvim/lua/config/keymaps.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>ocd', ':e ~/.config/nvim/lua/config/autocmds.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>oco', ':e ~/.config/nvim/lua/config/options.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>ocl', ':e ~/.config/nvim/lua/config/lazy.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>oczl', ':e ~/.config/nvim/lua/config/lsp.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>ocp', ':e ~/.config/nvim/lua/plugins/main.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>ocf', ':e ~/.config/nvim/lua/helpers/functions.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>oca', ':e ~/.config/nvim/lua/helpers/after.lua<CR>`.zz')
	vim.keymap.set('n', '<leader>oq', ':e ~/synced/brainstore/input.txt<CR>`.zz')
	vim.keymap.set('n', '<leader>ohh', ':e ~/configuration/nixos/users/' .. user .. '/home.nix<CR>`.zz')
	vim.keymap.set('n', '<leader>op', ':e ~/configuration/nixos/users/' .. user .. '/packages.nix<CR>`.zz')
	vim.keymap.set('n', '<leader>on', ':e ~/configuration/nixos/configuration.nix<CR>`.zz')
	vim.keymap.set('n', '<leader>om', ':e ~/configuration/nixos/modules<CR>')
	vim.keymap.set('n', '<leader>ow', ':e ~/synced/brainstore/waste.txt<CR>')
	vim.keymap.set('n', '<leader>oho', ':e ~/configuration/nixos/hosts<CR>')
	vim.keymap.set('n', '<leader>os', ':e ~/configuration/nixos/modules/server<CR>')
	vim.keymap.set('n', '<leader>ot', ':e ~/synced/brainstore/todos/todo.txt<CR>`.zz')
	vim.keymap.set('n', '<leader>od', ':e ~/synced/brainstore/todos/done.txt<CR>`.zz')
	vim.keymap.set('n', '<leader>ou', ':e ~/projects/university/' .. season .. '/input.txt<CR>`.zz')
	vim.keymap.set('n', '<leader>oz', ':e ~/.zshrc<CR>`.zz')
	vim.keymap.set('n', '<leader>oaa', ':e ~/.common_shell<CR>`.zz')
	-- Map the function to a keybinding (e.g., <leader>lf to open the last file)
	vim.keymap.set("n", "<leader>or", "<cmd>lua open_last_file()<CR>", { noremap = true, silent = true })
	-- open the calendar
	--
	function open_cal()
		local current_date = os.date("%Y-%m-%d")
		local week_number = os.date("%V")
		local day_of_week = os.date("%a")
		local path = "~/synced/brainstore/calendar/calendar_" .. os.date("%Y") .. ".txt"
		local keys = ":e " .. path .. "<CR>/" .. current_date .. " w" .. tonumber(week_number) .. " " .. day_of_week .. "<CR>$"
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
	end

	vim.keymap.set('n', '<leader>ok', open_cal)
	-------------------------------------------------------------------------------------

	vim.keymap.set("n", "<leader>lf", links.insert_brainstore_link, { desc = "Link Brainstore file" })
	vim.keymap.set("n", "<leader>lm", links.insert_mail_link, { desc = "Link Mail" })
	vim.keymap.set('n', '<leader>ll', ':Lazy<CR>')
	vim.keymap.set("n", "<leader>lp", links.insert_project_link, { desc = "Link Project" })
	vim.keymap.set("n", "<leader>lc", links.insert_contact_link, { desc = "Link Contact" })
	vim.keymap.set("n", "<leader>ld", links.insert_date_link, { desc = "Link Contact" })


	-- nvim tree
	vim.keymap.set("n", "<leader>e", function()
		api.tree.toggle({ find_file = true, update_root = true, focus = true, })

	end, { silent = true }) -- also update the root with the bang

	vim.keymap.set('n', '<leader>ia', 'gg=G<C-o>zz')
	vim.keymap.set('n', '<leader>ya', 'ggVG"+y<C-o>')

	-- Map <leader>q to save and quit all buffers with error handling
	-- Dangerous but feels good

	vim.keymap.set('n', '<leader>ss', ':wa<CR>')
	vim.keymap.set('n', '<leader>sw', function()
		local word = vim.fn.expand("<cword>")
		local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
		if replacement ~= "" then
			vim.cmd(string.format("%%s/\\<%s\\>/%s/gI", vim.fn.escape(word, '\\/'), vim.fn.escape(replacement, '\\/')))
		end
	end, { desc = "Substitute word under cursor (prompt)" })
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
	-- vim.keymap.set('n', '<leader>sl', search_brain_links)

	vim.keymap.set('n', '<leader>pp', function()
		vim.api.nvim_command('normal! "+p')
	end, { desc = 'Paste from system clipboard' })

	-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fr', function()
		require('telescope.builtin').oldfiles({
			disable_devicons = true,
		})
	end, { noremap = true, silent = true })
	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
	vim.keymap.set("n", "<leader>fl", links.follow_link, { desc = "Follow Link" })


	vim.keymap.set('n', '<leader>g', function()
		require('telescope.builtin').live_grep({
			disable_devicons = true,
			cwd = vim.fn.getcwd(), -- set the starting directory
			additional_args = function()
				return { '--hidden', '--glob', '!.git/*' } -- include hidden files but exclude .git
			end,
		})
	end, { noremap = true, silent = true })

	vim.keymap.set('n', '<leader><leader>', find_eff, { desc = 'Telescope find files (with dotfiles and folders but excluding .git, .cache, .local, and large files)' })

	------------------------ VISUAL ------------------

	vim.keymap.set('v', 'p', function()
		local unnamed_content = vim.fn.getreg('""')
		vim.api.nvim_command('normal! p')
		vim.fn.setreg('""', unnamed_content)
	end, { desc = 'Paste from unnamed register (don\'t overwrite it) in visual mode' })
	vim.keymap.set('v', '<leader>y', function()
		vim.cmd('normal! "+y')
		vim.cmd('normal! gv')
	end, { desc = 'Yank to clipboard and keep the selection' })  


	---------------------------- INSERT ---------------------------

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
end

