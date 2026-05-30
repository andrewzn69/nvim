return function(on_attach)
	return {
		on_attach = on_attach,
		on_init = function(client)
			local root = client.config.root_dir
			if not root then
				return
			end

			local modules_dir = root .. "/.terraform/modules"
			local modules_json = modules_dir .. "/modules.json"
			local main_tf = root .. "/main.tf"

			if vim.fn.isdirectory(modules_dir) == 0 then
				return
			end
			if vim.fn.filereadable(main_tf) == 0 then
				return
			end

			-- get keys from existing modules.json
			local existing_keys = {}
			if vim.fn.filereadable(modules_json) == 1 then
				local f = io.open(modules_json, "r")
				if f then
					local ok, parsed = pcall(vim.json.decode, f:read("*all"))
					f:close()
					if ok and parsed.Modules then
						for _, m in ipairs(parsed.Modules) do
							if m.Key ~= "" then
								existing_keys[m.Key] = true
							end
						end
					end
				end
			end

			-- get actual module directories
			local dir_names = {}
			for _, d in ipairs(vim.fn.glob(modules_dir .. "/*/", false, true)) do
				dir_names[vim.fn.fnamemodify(d, ":h:t")] = true
			end

			-- check for drift
			local has_drift = false
			for name in pairs(dir_names) do
				if not existing_keys[name] then
					has_drift = true
					break
				end
			end
			if not has_drift then
				for name in pairs(existing_keys) do
					if not dir_names[name] then
						has_drift = true
						break
					end
				end
			end

			if not has_drift then
				return
			end

			local tmp = modules_json .. ".tmp"
			local cmd = string.format(
				[[awk '
/^module "/ { match($0, /"([^"]+)"/, arr); name=arr[1] }
/source *= *"/ && name { match($0, /"([^"]+)"/, arr); src=arr[1];
  printf ",\n    {\"Key\": \"%%s\", \"Source\": \"%%s\", \"Dir\": \".terraform/modules/%%s\"}", name, src, name;
  name="" }
' %s | awk 'BEGIN { printf "{\n  \"Modules\": [\n    {\"Key\": \"\", \"Source\": \"\", \"Dir\": \".\"}" } { print } END { printf "\n  ]\n}\n" }' > %s && mv %s %s]],
				main_tf,
				tmp,
				tmp,
				modules_json
			)

			vim.fn.system(cmd)
		end,
	}
end
