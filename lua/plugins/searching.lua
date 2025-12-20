return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "FzfLua" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		keys = {
			{
				"<leader>tt",
				":Telescope<CR>",
				desc = "Telescope menu",
			},
			{
				"<C-p>",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Fzf current buffers"
			},
			{
				"<leader>fr",
				function()
					require('telescope.builtin').oldfiles({
						disable_devicons = false,
					})
				end,
				desc = "Open last files"
			},

			{
				"<leader>g",
				function()
					require('utils.functions').fzf_wrapped("grep")
                end
			},
			{
				"<leader>fh",
				function()
					require('telescope.builtin').help_tags()
				end,
			},
			{
				"<leader><leader>",
				function()
					require('utils.functions').fzf_wrapped("find")
                end
			}
		},
		config = true,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		opts = {
			extensions = {
				undo = {
					side_by_side = true,
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.7,
					},
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	}
}
