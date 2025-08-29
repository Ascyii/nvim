-- Disable lsp stuff
-- xzl
-- setup mason
-- xzl
--require("mason").setup()
--require("mason-lspconfig").setup({
--	ensure_installed = { "rust_analyzer", "pyright" }, -- Example LSPs
--})

-- Example: Configure a server
-- TODO: this has to be done better and automatically
--local lspconfig = require("lspconfig")
--lspconfig.rust_analyzer.setup({})
--lspconfig.pyright.setup({})


if vim.g.diffm then
	-- setup tree
	require("nvim-tree").setup({
		sort_by = "case_sensitive",
		view = {
			width = 35,
		},
		disable_netrw = false,
	})
else
	-- stuff for only main
	require 'telescope'.setup {
		extensions = {
		},
	}

	-- load custom todo plugin
	require("custom.todo").setup()


	-- configure a workflow that integrates image support in documents and a quick opening of them
	local base_zet = "~/synced/brainstore/zettelkasten"
	require('telekasten').setup({
		home = vim.fn.expand(base_zet), -- Put the name of your notes directory here
		dailies = vim.fn.expand(base_zet .. "/daily"),
		-- how to change the defualt media folder?
		image_subdir = vim.fn.expand(base_zet .. "/media"),
		weeklies = vim.fn.expand(base_zet .. "/weekly"),
		templates = vim.fn.expand(base_zet .. "/templates"),
		template_new_note = vim.fn.expand(base_zet .. "/templates/note.md"),
		template_new_daily = vim.fn.expand(base_zet .. "/templates/daily.md"),
		template_new_weekly = vim.fn.expand(base_zet .. "/templates/weekly.md"),

		-- auto_set_filetype = false,
		-- Important part:
		filename_format = "%Y%m%d%H%M-%title%", -- This adds the timestamp + slugged title
		new_note_filename = "uuid-title", -- Set naming convention to use uuid first
		uuid_type = "%Y%m%d%H%M",         -- Timestamp as UUID
		uuid_separator = "-",
	})

	-- setup tree
	require("nvim-tree").setup({
		sort_by = "case_sensitive",
		-- open_on_tab = true,

		view = {
			width = 35,
			side = "right",
			preserve_window_proportions = true,
			number = false,
			relativenumber = false,
		},
		update_focused_file = {
			enable = false,
		},

		renderer = {
			group_empty = true,
			highlight_git = true,
			highlight_opened_files = "name",
			indent_markers = {
				enable = true,
			},
			icons = {
				show = {
					file = false,
					folder = false,
					folder_arrow = true,
					git = false,
					modified = false,
					hidden = false,
					diagnostics = false,
				},
			},
		},

		filters = {
			dotfiles = false, -- << SHOW dotfiles by default
			git_clean = false,
			no_buffer = false,
			custom = { ".DS_Store", ".git" }, -- Mac stuff you probably don't need
		},

		git = {
			enable = true,
			ignore = false, -- so it shows even ignored files
		},

		actions = {
			open_file = {
				quit_on_open = false, -- keep tree open after opening a file
				resize_window = true,
			},
		},

	})
end

-- stuff for both

-- lualine mode for the current workingdir
local function get_cwd()
	local cwd = vim.fn.getcwd()
	local home = os.getenv("HOME")

	-- Check if the current directory starts with the home directory path
	if cwd:sub(1, #home) == home then
		return "~" .. cwd:sub(#home + 1)
	else
		return cwd
	end
end

require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'gruvbox',
		-- think those icons are okay
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 300,
			tabline = 300,
			winbar = 300,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { get_cwd, 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	extensions = { "nvim-tree" }
}



require('gitsigns').setup {
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end


		map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
			vim.cmd("normal! zz") -- center cursor
		end, { silent = true })

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
			vim.cmd("normal! zz") -- center cursor
		end, { silent = true })

		-- Actions
		map('n', '<leader>hs', gitsigns.stage_hunk)
		map('n', '<leader>hr', gitsigns.reset_hunk)

		map('v', '<leader>hs', function()
			gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end)

		map('v', '<leader>hr', function()
			gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end)

		map('n', '<leader>hS', gitsigns.stage_buffer)
		map('n', '<leader>hR', gitsigns.reset_buffer)
		map('n', '<leader>hp', gitsigns.preview_hunk)
		map('n', '<leader>hi', gitsigns.preview_hunk_inline)


		map('n', '<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end)

		map('n', '<leader>hd', gitsigns.diffthis)

		map('n', '<leader>hD', function()
			gitsigns.diffthis('~')
		end)

		map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
		map('n', '<leader>hq', gitsigns.setqflist)

		-- Toggles
		map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
		map('n', '<leader>tw', gitsigns.toggle_word_diff)

		-- Text object
		map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
	end
}

require("lspsaga").setup({
	lightbulb = {
		enable = false,
		enable_in_insert = false, -- don’t show in insert mode
		sign = false,

		virtual_text = false,
	},
	ui = {
	}
})
