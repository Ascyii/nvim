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
		config = function()
			require("custom.todo").setup()
		end,
	},
	{
		dir = get_custom_dir(),
		name = "typst",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>tw", function() require("custom.typst").Watch_and_open() end, desc = "Watch Typst" },
		},
	},
}
