
return {
	{
		"ThePrimeagen/harpoon",
		config = function()
			vim.keymap.set("n", "<leader>af", function()
				require("harpoon.mark").add_file()
			end)
			vim.keymap.set("n", "<leader>hf", function()
				require("harpoon.ui").toggle_quick_menu()
			end)
			vim.keymap.set("n", "<leader>Hn", function()
				require("harpoon.ui").nav_next()
			end)
			vim.keymap.set("n", "<leader>Hp", function()
				require("harpoon.ui").nav_prev()
			end)
		end
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			-- Cannot setup with opts here need to call before using the command for the plugin
			require("toggleterm").setup({
				size = 20,
				direction = "horizontal",
			})

			local first_open = false
			local function toggle_term()
				vim.cmd("ToggleTerm")
				if first_open == true then
					vim.cmd("startinsert")
				end
			end

			vim.keymap.set("n", "<C-/>", toggle_term, { noremap = true, silent = true })
			vim.keymap.set("t", "<C-/>", toggle_term, { noremap = true, silent = true })
		end
	},
	{
		'Ascyii/telekasten.nvim',
		dev = true,
		config = function()
			local base_zet = "~/synced/brainstore/zettelkasten"

			-- Again can only use opts when not using config
			require("telekasten").setup({
				home = vim.fn.expand(base_zet),
				dailies = vim.fn.expand(base_zet .. "/daily"),

				image_subdir = vim.fn.expand(base_zet .. "/media"),
				weeklies = vim.fn.expand(base_zet .. "/weekly"),
				templates = vim.fn.expand(base_zet .. "/templates"),
				template_new_note = vim.fn.expand(base_zet .. "/templates/note.md"),
				template_new_daily = vim.fn.expand(base_zet .. "/templates/daily.md"),
				template_new_weekly = vim.fn.expand(base_zet .. "/templates/weekly.md"),

				filename_format = "%Y%m%d%H%M-%title%",
				new_note_filename = "uuid-title",
				uuid_type = "%Y%m%d%H%M",
				uuid_separator = "-",
			})

			-- Telekasten occupies the z namespace
			vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")
			vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
			vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
			vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
			vim.keymap.set("n", "<leader>zr", "<cmd>Telekasten rename_note<CR>")
			vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
			vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
			vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
			vim.keymap.set("n", "<leader>zw", "<cmd>Telekasten find_weekly_notes<CR>")
			vim.keymap.set("n", "<leader>il", "<cmd>Telekasten insert_link<CR>")
			vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")
		end
	},
};
