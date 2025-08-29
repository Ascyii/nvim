local utils = require("utils.functions")

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = { mappings = false, },
			delay = 1500,
		},
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		},
		opts = {
			options = {
				icons_enabled = true,
				theme = 'gruvbox',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				always_divide_middle = true,
				always_show_tabline = false,
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
				lualine_c = { utils.get_cwd(), 'filename' },
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' }
			},
			extensions = { "nvim-tree" } -- show another line on the tree
		}
	},
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		opts = {
			clickable = false,
			tabpages = false,
			animations = false,
			icons = { filetype = { enabled = false } }
		},
		version = '^1.0.0', -- only update when a new 1.x version is released
		config = function()
			vim.keymap.set("n", "L", ":BufferNext<CR>", { silent = true })
			vim.keymap.set("n", "H", ":BufferPrevious<CR>", { silent = true })

			vim.keymap.set("n", "<leader>bd", ":BufferDelete<CR>")
		end
	},

	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard")
		end
	}
}
