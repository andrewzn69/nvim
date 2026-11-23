return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		cmd = { 'biome', 'lsp-proxy' },
		filetypes = {
			'astro',
			'css',
			'graphql',
			'javascript',
			'javascriptreact',
			'json',
			'jsonc',
			'svelte',
			'typescript',
			'typescript.tsx',
			'typescriptreact',
			'vue',
		},
		single_file_support = false,
		docs = {
			description = [[
https://biomejs.dev

Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).

```sh
npm install [-g] @biomejs/biome
```
]],
		},
	}
end
