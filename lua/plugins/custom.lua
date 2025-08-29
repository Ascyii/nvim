-- Custom modules

--- @param name string
--- @return string
local function get_dir(name)
	return vim.fn.stdpath("config") .. "/lua/custom/" .. name
end

return {
	{
		dir = get_dir("todo"),
		name = "todo",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("custom.todo").setup()
		end,
	},
	{
		dir = vim.fn.stdpath("config") .. "/lua/custom", -- folder containing typst.lua
		name = "typst",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>tw", function() require("custom.typst").Watch_and_open() end, desc = "Watch Typst" },
		},
	},
}
