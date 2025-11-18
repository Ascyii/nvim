return {
	"ellisonleao/gruvbox.nvim",

	config = function()
		-- Useful for terminal emulators with a transparent background
		local function transparentBackground()
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end

        require("gruvbox").setup({
            palette_overrides = {
                bright_yellow = "#AD5944"; -- workaround
            }
        })

		vim.cmd.colorscheme("gruvbox")

		transparentBackground()
	end
}
