vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.swapfile = false
vim.o.hlsearch = false
vim.o.scrolloff = 8
vim.o.incsearch = true
vim.o.termguicolors = true

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bg = "none", bold = true })

vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })
