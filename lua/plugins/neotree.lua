return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = { "MunifTanjim/nui.nvim", lazy = true },
	opts = function(_, opts)
		opts.filesystem = {
			follow_current_file = { enabled = true },
			filtered_items = {
				visible = true,
				hide_dotfiles = true,
				hide_gitignored = true,
			},
		}
		opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types or
				{ "terminal", "Trouble", "qf", "Outline", "trouble" }
		table.insert(opts.open_files_do_not_replace_types, "edgy")
	end,
}
