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
						no_ignore = true, -- Also show files in gitignore
						follow = true,
						disable_devicons = true,
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
}
