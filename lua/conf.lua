local config = {}

config.season = "S3"
config.projects = vim.fn.expand("~/projects")
config.uni_dir = vim.fn.expand("~/projects/university/" .. config.season)

return config
