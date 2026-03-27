local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})

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

vim.keymap.set("n", "<leader>e", vim.cmd.Oil)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<CR>", "m`o<Esc>``")
vim.keymap.set("n", "<S-CR>", "m`O<Esc>``")

vim.keymap.set("n", "<leader>w", function()
	vim.diagnostic.open_float(nil, {
		border = "rounded",
		style = "minimal",
		focusable = false,
	})
end, { silent = true })

local term_buf = nil
local term_win = nil

term_buf = nil
term_win = nil

function TermToggle(height)
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.cmd("hide")
	else
		vim.cmd("botright new")
		local new_buf = vim.api.nvim_get_current_buf()
		vim.cmd("resize " .. height)
		if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
			vim.cmd("buffer " .. term_buf)
			vim.cmd("bd " .. new_buf) -- cleanup new buffer
		else
			vim.cmd("terminal")

			term_buf = vim.api.nvim_get_current_buf()

			vim.wo.number = false

			vim.wo.relativenumber = false

			vim.wo.signcolumn = "no"
		end

		vim.cmd("startinsert!")

		term_win = vim.api.nvim_get_current_win()
	end
end

-- function RunCpp()

-- 	-- Save the current file

-- 	vim.cmd("write")

-- 	-- Get the current file name

-- 	local file = vim.fn.expand("%:p")

-- 	-- Get the file name without extension for the output binary

-- 	local output = vim.fn.expand("%:p:r")

-- 	-- Compile the C++ file

-- 	local compile_cmd = "g++ -o " .. output .. " " .. file

-- 	-- Run the compiled program using the full path

-- 	local run_cmd = output -- Use the full path directly

-- 	-- Check if on Windows (use .exe extension)

-- 	if vim.fn.has("win32") == 1 then

-- 		run_cmd = output .. ".exe"

-- 	end

-- 	-- Open terminal if not already open

-- 	TermToggle(10)

-- 	-- Ensure terminal buffer is valid before sending commands

-- 	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then

-- 		-- Clear terminal and send compile + run commands

-- 		vim.api.nvim_chan_send(

-- 			vim.api.nvim_buf_get_option(term_buf, "channel"),

-- 			"clear && " .. compile_cmd .. " && " .. run_cmd .. "\r"

-- 		)

-- 	else

-- 		print("Error: Terminal buffer is not valid")

-- 	end

-- end

function RunCpp()
	-- Save the current file

	vim.cmd("write")

	-- Get the current file name

	local file = vim.fn.expand("%:p")

	-- Get the file name without extension for the output binary

	local output = vim.fn.expand("%:p:r")

	-- Compile the C++ file

	local compile_cmd = "g++ -o " .. output .. " " .. file

	-- Run the compiled program using the full path

	local run_cmd = output -- Use the full path directly

	local delete_cmd = "rm " .. output -- Default delete command

	-- Check if on Windows (use .exe extension)

	if vim.fn.has("win32") == 1 then
		run_cmd = output .. ".exe"

		delete_cmd = "del " .. output .. ".exe" -- Windows delete command
	end

	-- Open terminal if not already open

	TermToggle(10)

	-- Ensure terminal buffer is valid before sending commands

	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		-- Clear terminal and send compile + run + delete commands

		vim.api.nvim_chan_send(
			vim.api.nvim_buf_get_option(term_buf, "channel"),
			"clear && " .. compile_cmd .. " && " .. run_cmd .. " && " .. delete_cmd .. "\r"
		)
	else
		print("Error: Terminal buffer is not valid")
	end
end

vim.keymap.set("n", "<leader>pt", ":lua TermToggle(10)<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<leader>pt", "<C-\\><C-n>:lua TermToggle(10)<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", ":lua RunCpp()<CR>", { noremap = true, silent = true })
vim.cmd(":Oil")
