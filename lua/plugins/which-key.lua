return {
	"folke/which-key.nvim",
	keys = { "<leader>" },
	config = function()
		require("which-key").setup({
			plugins = {
				spelling = {
					enabled = true,
					suggestions = 20,
				},
			},
			delay = 400,
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "a",      mode = { "n", "v" } },
			},
			win = {
				no_overlap = true,
				border = "rounded",
				padding = { 1, 2 },
			},
		})
	end,
}
