-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			component_separators = "",
			section_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { "filename", "branch", "diff" },
			lualine_c = {
				{
					"diagnostics",
					source = { "nvim" },
					sections = { "error" },
				},
				{
					"diagnostics",
					source = { "nvim" },
					sections = { "warn" },
				},
			},
			lualine_x = {
				{
					function()
						local msg = "No Active Lsp"
						local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
						local clients = vim.lsp.get_clients()
						if next(clients) == nil then
							return msg
						end
						--luau-lsp does not have config.filetypes
						if buf_ft == "luau" then
							for _, client in ipairs(clients) do
								if client.name == "luau-lsp" then
									return "luau-lsp"
								end
							end
						end
						for _, client in ipairs(clients) do
							local filetypes = client.config.filetypes
							if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
								return client.name
							end
						end
						return msg
					end,
					icon = " LSP:",
				},
				"%=",
			},
			lualine_y = { "filetype", "progress" },
			lualine_z = {
				{ "location", separator = { right = "" }, left_padding = 2 },
			},
		},
		inactive_sections = {
			lualine_a = { "filename" },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "location" },
		},
		extensions = {},
	},
}
