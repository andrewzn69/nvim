return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	lazy = true,
	priority = 500,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		lazy = true
	},
	init = function()
		-- disable until lualine loads
		vim.opt.laststatus = 3
	end,
	opts = function()
		-- config
		local function current_time()
			return os.date(' %H:%M')
		end
		local config = {
			options = {
				icons_enabled = true,
				theme = 'auto',
				section_separators = { left = '', right = '' },
				component_separators = { left = '', right = '' },
				disabled_filetypes = { 'alpha', 'Avante', 'AvanteInput' }
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch' },
				lualine_c = { {
					'filename',
					file_status = true, -- displays file status (readonly status, modified status)
					path = 1       -- 0 = just filename, 1 = relative path, 2 = absolute path
				} },
				lualine_x = {
					{
						'diagnostics',
						sources = { "nvim_diagnostic" },
						symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
					},
					'',
					'filetype'
				},
				lualine_y = { 'progress', 'location' },
				lualine_z = { current_time }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { {
					'filename',
					file_status = true,
					path = 1
				} },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
						color = { bg = 'NONE' },
					},
					{
						"filename",
						path = 0,
						separator = " >",
						padding = { left = 0, right = 0 },
						color = { fg = vim.fn.synIDattr(vim.fn.hlID("NavicText"), "fg") },
					},
					{
						"navic",
						color = { bg = 'NONE' },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { 'fugitive' }
		}
		return config
	end,
}
