local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[░█████╗░░██████╗░█████╗░██╗░░░██╗██╗██╗]],
	[[██╔══██╗██╔════╝██╔══██╗╚██╗░██╔╝██║██║]],
	[[███████║╚█████╗░██║░░╚═╝░╚████╔╝░██║██║]],
	[[██╔══██║░╚═══██╗██║░░██╗░░╚██╔╝░░██║██║]],
	[[██║░░██║██████╔╝╚█████╔╝░░░██║░░░██║██║]],
	[[╚═╝░░╚═╝╚═════╝░░╚════╝░░░░╚═╝░░░╚═╝╚═╝]],
}

dashboard.section.buttons.val = {
	dashboard.button("e", "New File", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "Recent Files", ":Telescope oldfiles<CR>"),
	dashboard.button("c", "Config", ":e $MYVIMRC<CR>"),
	dashboard.button("q", "Quit", ":qa<CR>"),
}

dashboard.section.footer.val = "Welcome to Neovim! Enjoy!"

dashboard.section.header.opts.hl = "include"
dashboard.section.buttons.opts.hl = "keyword"
dashboard.section.footer.opts.hl = "type"

local screen_height = vim.fn.winheight(0)
local content_height =
	#dashboard.section.header.val +
	#dashboard.section.buttons.val +
	#dashboard.section.footer.val

dashboard.opts.layout = {
	{ type = "padding", val = math.floor((screen_height - content_height) / 2) },
	dashboard.section.header,
	{ type = "padding", val = 2 },
	dashboard.section.buttons,
	{ type = "padding", val = 1 },
	dashboard.section.footer,
}

alpha.setup(dashboard.opts)
