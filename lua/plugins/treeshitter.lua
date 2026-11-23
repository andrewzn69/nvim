return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = "BufReadPost",
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable" },
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")

		---@diagnostic disable-next-line
		treesitter.setup({
			ensure_installed = {
				"astro",
				"bash",
				"css",
				"c_sharp",
				"dockerfile",
				"elixir",
				"go",
				"gotmpl",
				"graphql",
				"gitcommit",
				"gitignore",
				"git_config",
				"git_rebase",
				"hcl",
				-- "helm",
				"html",
				"hyprlang",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"php",
				"prisma",
				"python",
				"rasi",
				"regex",
				"regex",
				"ruby",
				"rust",
				"scss",
				"sql",
				"terraform",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml",
				"yuck",
			},
			-- highlight, match, indent are neovim built-ins in 0.10+
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "zi",
					node_incremental = "zi",
					scope_incremental = "zo",
					node_decremental = "zd",
				},
			},
			-- textobjects = {
			--   select = {
			--     enable = true,
			--     lookahead = true,
			--     keymaps = {
			--       ["af"] = "@function.outer",
			--       ["if"] = "@function.inner",
			--       ["ac"] = "@class.outer",
			--       ["ic"] = "@class.inner",
			--
			--       -- xml attribute
			--       ["ax"] = "@attribute.outer",
			--       ["ix"] = "@attribute.inner",
			--
			--       -- json
			--       ["ak"] = "@key.outer",
			--       ["ik"] = "@key.inner",
			--       ["av"] = "@value.outer",
			--       ["iv"] = "@value.inner",
			--     },
			--   },
			swap = {
				enable = true,
				swap_next = {
					["<leader>rp"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>rP"] = "@parameter.inner",
				},
			},
			--   move = {
			--     enable = true,
			--     set_jumps = true, -- whether to set jumps in the jumplist
			--     goto_next_start = {
			--       ["]m"] = "@function.outer",
			--       ["]]"] = "@class.outer",
			--     },
			--     goto_next_end = {
			--       ["]M"] = "@function.outer",
			--       ["]["] = "@class.outer",
			--     },
			--     goto_previous_start = {
			--       ["[m"] = "@function.outer",
			--       ["[["] = "@class.outer",
			--     },
			--     goto_previous_end = {
			--       ["[M"] = "@function.outer",
			--       ["[]"] = "@class.outer",
			--     },
			--   },
			-- },
		})

		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok and parsers.get_parser_configs then
			local parser_config = parsers.get_parser_configs()
			if parser_config.gotmpl then
				parser_config.gotmpl.used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "helm" }
			end
		end

		vim.filetype.add({
			pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
		})

		local r = require("utils.remaps")
		r.noremap("n", "<leader>dp", function()
			vim.treesitter.inspect_tree({ command = "botright 60vnew" })
		end, "treesitter playground")

		r.noremap("n", "<C-e>", function()
			local result = vim.treesitter.get_captures_at_cursor(0)
			print(vim.inspect(result))
		end, "show treesitter capture group")

		r.map_virtual("zi", "init selection")
		r.map_virtual("zi", "expand node")
		r.map_virtual("zo", "expand scope")
		r.map_virtual("zd", "decrement scope")

		-- r.map_virtual("af", "Function outer motion")
		-- r.map_virtual("if", "Function inner motion")
		-- r.map_virtual("ac", "Class outer motion")
		-- r.map_virtual("ic", "Class inner motion")
		--
		-- r.map_virtual("ax", "Attribute (html, xml) outer motion")
		-- r.map_virtual("ix", "Attribute (html, xml) inner motion")
		--
		-- r.map_virtual("ak", "Json key outer motion")
		-- r.map_virtual("ik", "Json key inner motion")
		--
		-- r.map_virtual("av", "Json value outer motion")
		-- r.map_virtual("iv", "Json value inner motion")
		--
		-- r.which_key("fp", "parameters")
		--
		r.map_virtual("<leader>rp", "swap parameter to next")
		r.map_virtual("<leader>rP", "swap parameter to previous")
		--
		-- r.map_virtual("]m", "Go to next function (start)")
		-- r.map_virtual("]M", "Go to next function (end)")
		--
		-- r.map_virtual("]]", "Go to next class (start)")
		-- r.map_virtual("][", "Go to next class (end)")
		--
		-- r.map_virtual("[m", "Go to previous function (start)")
		-- r.map_virtual("[M", "Go to previous function (end)")
		--
		-- r.map_virtual("[[", "Go to previous class (start)")
		-- r.map_virtual("[]", "Go to previous class (end)")
	end,
}
