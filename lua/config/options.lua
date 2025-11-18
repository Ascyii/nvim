vim.o.shiftwidth = 4;
vim.o.tabstop = 4;
vim.o.number = true;
vim.opt.relativenumber = true
vim.o.ignorecase = true;
--vim.o.guicursor = "n-v-c-sm-i-ci-ve:block";
vim.o.cursorline = true
vim.cmd([[
    highlight CursorLine cterm=NONE guibg=#4c3c3c
]])


-- Disable mouse completly
vim.o.mouse = "";

-- Turn on undofile
vim.o.udf = true;
vim.opt.undolevels = 10000 -- Default is 1000
vim.opt.undoreload = 10000

-- Enable more colors
vim.opt.termguicolors = true

--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

--vim.opt.signcolumn = "number"
vim.opt.signcolumn = "yes:1"

-- Enable Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99 -- open all folds by default
vim.opt.fillchars = "fold:╌"

vim.g.GPGDefaultRecipients = {"C6772451703DE183A4983CBA063DC054484835A6"}

vim.o.expandtab = true      -- Use spaces instead of tabs
vim.o.smarttab = true       -- Insert 'shiftwidth' spaces when pressing Tab
