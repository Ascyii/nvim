return {
	"nvim-tree/nvim-tree.lua",
	keys = {
		{ "<leader>e", function()
			require("nvim-tree.api").tree.toggle({
				find_file = true,
				update_root = true,
				focus = true,
			})
		end
		}
	},
	opts = {
		sort_by = "case_sensitive",
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
			dotfiles = false,
			git_clean = false,
			no_buffer = false,
			custom = { ".git" },
		},
		git = {
			enable = true,
			ignore = false,
		},
		actions = {
			open_file = {
				quit_on_open = false,
				resize_window = true,
			},
		},
	}
}
