return {
	{
		"youyoumu/pretty-ts-errors.nvim",
		opts = {
			executable = "pretty-ts-errors-markdown", -- Path to the executable
			float_opts = {
				border = "rounded",                 -- Border style for floating windows
				max_width = 80,                     -- Maximum width of floating windows
				max_height = 20,                    -- Maximum height of floating windows
			},
			auto_open = true,                     -- Automatically show errors on hover
		}
	},
}
