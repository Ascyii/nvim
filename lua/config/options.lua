vim.o.shiftwidth = 4;
vim.o.tabstop = 4;
vim.o.number = true;
vim.o.ignorecase = true;

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

vim.opt.signcolumn = "yes"

-- Enable Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99 -- open all folds by default
vim.opt.fillchars = "fold:╌"
