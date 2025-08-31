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
						disable_devicons = true,
					})
				end,
				desc = "Open last files"
			},

			{
				"<leader>g",
				function()
					require('telescope.builtin').live_grep({
						disable_devicons = true,
						cwd = vim.fn.getcwd(),
						additional_args = function()
							return { '--hidden', '--glob', '!.git/*' }
						end,
					})
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
					require('telescope.builtin').find_files({
						hidden = true,
						no_ignore = true,
						follow = true,
						disable_devicons = false,
						prompt_title = "Find Files",
						find_command = {
							"rg", "--files",
							"--glob", "!**/.git/*",
							"--glob", "!**/build/*",
							"--glob", "!**/*.{jpg,png,gif,mp4,mkv,tar,zip,iso}"
						}
					})
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
