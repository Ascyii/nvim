local base_zet = "~/synced/brainstore/zettelkasten"

return {
	{ "ThePrimeagen/harpoon" },
	{ "akinsho/toggleterm.nvim", config = true },
	{
		'Ascyii/telekasten.nvim',
		dev = true,
		opts = {
			home = vim.fn.expand(base_zet),
			dailies = vim.fn.expand(base_zet .. "/daily"),

			image_subdir = vim.fn.expand(base_zet .. "/media"),
			weeklies = vim.fn.expand(base_zet .. "/weekly"),
			templates = vim.fn.expand(base_zet .. "/templates"),
			template_new_note = vim.fn.expand(base_zet .. "/templates/note.md"),
			template_new_daily = vim.fn.expand(base_zet .. "/templates/daily.md"),
			template_new_weekly = vim.fn.expand(base_zet .. "/templates/weekly.md"),

			filename_format = "%Y%m%d%H%M-%title%",
			new_note_filename = "uuid-title",
			uuid_type = "%Y%m%d%H%M",
			uuid_separator = "-",
		}
	},
};
