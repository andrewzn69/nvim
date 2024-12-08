return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = { "MunifTanjim/nui.nvim", lazy = true },
	opts = function(_, opts)
		opts.filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		}
		opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types or
				{ "terminal", "Trouble", "qf", "Outline", "trouble" }
		table.insert(opts.open_files_do_not_replace_types, "edgy")
	end,
}
