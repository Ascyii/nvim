--- @return string
local function get_cwd()
	local cwd = vim.fn.getcwd()
	local home = os.getenv("HOME")

	if cwd:sub(1, #home) == home then
		return "~" .. cwd:sub(#home + 1)
	else
		return cwd
	end
end

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
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				icons_enabled = false,
				theme = 'gruvbox',
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
	},
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function() vim.g.barbar_auto_setup = false end,
		cmd = { "BufferNext", "BufferPrevious" },
		opts = {
			clickable = false,
			tabpages = false,
			animations = false,
			icons = { filetype = { enabled = false } }
		},
		version = '^1.0.0', -- only update when a new 1.x version is released
	},
}
