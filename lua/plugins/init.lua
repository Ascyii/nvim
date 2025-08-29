local plugins = {}

if vim.g.diffm then
  vim.list_extend(plugins, require("plugins.diff"))
else
  vim.list_extend(plugins, require("plugins.main"))
end

return plugins
