return {
	{"sindrets/diffview.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		-- this is the nvim tree but I dont use it yet
		"nvim-tree/nvim-tree.lua",
	},
	{
		'nvim-lualine/lualine.nvim',
		-- dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"ellisonleao/gruvbox.nvim",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {mappings = false,},
			delay = 1500,
		},
	},
};
