--- @param name? string
--- @return string
local function get_custom_dir(name)
	if name == nil then
		return vim.fn.stdpath("config") .. "/lua/custom"
	end
	return vim.fn.stdpath("config") .. "/lua/custom/" .. name
end

return {
	{
		dir = get_custom_dir("todo"),
		name = "todo",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>ta", function() require("custom.todo").mark_done() end, desc = "Watch Typst" },
		},

	},
	{
		dir = get_custom_dir("typst"),
		name = "typst",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>tw", function() require("custom.typst").watch_and_open() end, desc = "Watch Typst" },
		},
	},
	{
		dir = get_custom_dir("journal"),
		name = "journal",
		config = function ()
			local journal = require("custom.journal")
			vim.keymap.set("n", "<leader>joup", function()
				journal.open_today()
			end, { desc = "Open todays journal" })
		end
	},
	{
		dir = get_custom_dir("uni"),
		name = "uni",
		config = function ()
			local uni = require("custom.uni")
			vim.keymap.set("n", "<leader>nv", function()
				uni.select_course_directory()
			end, { desc = "Open UniCourse menu" })
		end

	},
	{
		dir = get_custom_dir("linker"),
		name = "linker",
		config = function()
			local links = require("custom.linker")

			vim.keymap.set("n", "<leader>fl", links.follow_link, { desc = "Try to follow current link" })

			vim.keymap.set("n", "<leader>lf", links.insert_brainstore_link, { desc = "Link Brainstore file" })
			vim.keymap.set("n", "<leader>lm", links.insert_mail_link, { desc = "Link Mail" })
			vim.keymap.set("n", "<leader>lp", links.insert_project_link, { desc = "Link Project" })
			vim.keymap.set("n", "<leader>lc", links.insert_contact_link, { desc = "Link Contact" })
			vim.keymap.set("n", "<leader>ld", links.insert_date_link, { desc = "Link Contact" })
		end
	},
}
