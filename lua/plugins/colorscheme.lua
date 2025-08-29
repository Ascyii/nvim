return {
	"ellisonleao/gruvbox.nvim",

	config = function()
		-- Useful for terminal emulators with a transparent background
		local function transparentBackground()
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end

		vim.cmd.colorscheme("gruvbox")

		transparentBackground()
	end
}
