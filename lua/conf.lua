local config = {}

config.season = "S3" -- Current semester
config.projects = vim.fn.expand("~/projects")
config.uni_dir = vim.fn.expand("~/projects/university/" .. config.season)
config.user = vim.fn.system('whoami'):gsub('\n', '')

return config
