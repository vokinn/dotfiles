local dataFilePath = vim.fn.stdpath("data") .. "/colors" -- Use forward slash

local data = {
	default = "dracula",
	background = "light",
}

local function applyColors(color, mode)
	-- Wrap in pcall (protected call) so Neovim doesn't
	-- crash if the colorscheme isn't installed yet
	pcall(vim.cmd.colorscheme, color)
	vim.o.background = mode
end

function ColorMyPencils(color, mode)
	color = (color or data.default):lower()
	mode = mode or data.background

	-- Gruvbox logic
	if color == "gruvbox" then
		mode = "dark"
	elseif color == "vague" then
		-- Add any vague-specific overrides here if needed
	end

	applyColors(color, mode)

	-- THE FIXES:

	-- 1. Stop the cursorline from highlighting the gutter/numbers

	vim.opt.cursorlineopt = "line"

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

	-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bg = "none", bold = true })

	vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })

	local file = io.open(dataFilePath, "w+")
	if file then
		file:write(color .. "\n" .. mode .. "\n")
		file:close()
	end
end

-- Load saved colors on startup
local file = io.open(dataFilePath, "r")
if file then
	local colorscheme = file:read("*l")
	local background = file:read("*l")
	file:close()
	if colorscheme then
		data.default = colorscheme
	end
	if background then
		data.background = background
	end
end

return {
	{
		"vague2k/vague.nvim",
		lazy = false,
		priority = 1000,
		config = true,
	},

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
			})
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			-- ColorMyPencils("rose-pine")
		end,
	},
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		config = function()
			ColorMyPencils("gruvbox-material")
		end,
	},
}
