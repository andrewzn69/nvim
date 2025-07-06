return {
	{
		"yetone/avante.nvim",
		build = "make",
		version = false,
		opts = {
			provider = "copilot",

			selector = {
				provider = "telescope",
			},

			windows = {
				position = "right",
				wrap = true,
				width = 40,
				sidebar_header = {
					enabled = false,
					align = "center",
					rounded = true,
				},
				input = {
					prefix = "> ",
					height = 8,
					provider = "snacks",
				},
				edit = {
					border = "rounded",
					start_insert = true,
				},
				ask = {
					floating = false,
					start_insert = true,
					border = "rounded",
					focus_on_apply = "ours"
				},
			},
			providers = {
				copilot = {
					timeout = 30000,
					model = "gpt-4.1"
				},
				openrouter = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "deepseek/deepseek-chat-v3-0324",
					timeout = 30000, -- timeout in ms
				},
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "",
					timeout = 30000, -- timeout in ms
					extra_request_body = {
						temperature = 0.75,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- optional dependencies below
			"nvim-telescope/telescope.nvim", -- for file selector provider telescope
			"hrsh7th/nvim-cmp",           -- autocompletion for avante commands and mentions
			-- "ibhagwan/fzf-lua",           -- for file selector provider fzf
			"stevearc/dressing.nvim",     -- for input provider dressing
			"folke/snacks.nvim",          --  for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua",     -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
			{
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" }
				},
				ft = { "markdown", "Avante" },
			}
		}
	},
	vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", {
		fg = "#1D2021",
		bg = "#1D2021"
	}),
	vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", {
		fg = "#665C54",
		bg = "#1D2021"
	}),
}
