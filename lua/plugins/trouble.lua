return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup({
			modes = {
				diagnostics = {
					auto_open = false,
					auto_close = true,
				},
			},
			warn_no_results = false,
			-- stylua: ignore
			icons = require("utils.icons").trouble,
		})
		require("utils.remaps").map_virtual({
			{ "<leader>T", group = "trouble", icon = { icon = " ", hl = "Constant" } },
			{ "<leader>ts", group = "symbols", icon = { icon = " ", hl = "Constant" } },
		})
	end,
	keys = {
		{
			"<leader>Tt",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "trouble diagnostics",
		},
		{
			"<leader>TT",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "buffer diagnostics",
		},
		{
			"<leader>Ts",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "symbols",
		},
	},
}
