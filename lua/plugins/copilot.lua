return {
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
				debounce = 75,
				keymap = {
					accept = "<S-Tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = {
				enabled = true,
				auto_trigger = true
			},
			filetypes = {
				markdown = true,
				help = true,
				lua = true,
				bash = true,
				cs = true,
				python = true,
			},
		},
	},
	-- copilot cmp source
	{
		"nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				verylazy = true,
				dependencies = "copilot.lua",
				opts = {},
				config = function()
					require("copilot_cmp").setup()
				end,
			},
		},
	},
}
