return {
	"neovim/nvim-lspconfig",
	opts = {},
	dependencies = {
		"lopi-py/luau-lsp.nvim",
	},
	config = function()
		local orig_hover = vim.lsp.buf.hover
		vim.lsp.buf.hover = function()
			orig_hover({ border = "rounded", max_width = 80 })
		end

		vim.diagnostic.config({
			float = { border = "rounded" },
			update_in_insert = true,
		})

		require("lspconfig.ui.windows").default_options.border = "rounded"

		vim.lsp.enable("clangd")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("nixd")
		vim.lsp.enable("tinymist")
		vim.lsp.enable("basedpyright")

		vim.lsp.config("*", {
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			},
		})

		vim.lsp.config("tinymist", {
			settings = {
				exportPdf = "onType",
				outputPath = "$root/out/$name",
				previewFeature = "enable",
			},
		})

		vim.lsp.config("luau-lsp", {
			cmd = { "luau-lsp" },
			filetypes = { "luau" },
			root_markers = { ".git", ".luaurc" },
			on_attach = function(client, bufnr)
				client.server_capabilities.semanticTokensProvider = nil
			end,
		})

		require("luau-lsp").setup({
			platform = {
				type = "roblox",
			},
			types = {
				roblox_security_level = "PluginSecurity",
			},
			sourcemap = {
				enabled = true,
				autogenerate = true,
				sourcemap_file = "sourcemap.json",
				rojo_project_file = "default.project.json",
				rojo_path = "argon",
				include_non_scripts = false,
				generator_cmd = { "argon", "sourcemap", "--watch", "--non-scripts" },
			},
			fflags = {
				enable_new_solver = true,
			},
			plugin = {
				enabled = true,
				port = 3667,
				maximumRequestBodySize = "10mb",
			},
			completion = {
				autocompleteEnd = true,
			},
		})
	end,
}
