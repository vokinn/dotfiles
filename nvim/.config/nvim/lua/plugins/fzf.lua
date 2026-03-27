return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	-- Using config instead of opts for more control over keymaps
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			colorschemes = {
				actions = {
					["enter"] = function(selected)
						if #selected == 0 then
							return
						end
						-- Extract the name and pass it to your pencil function
						local theme = selected[1]:match("^[^:]+")
						ColorMyPencils(theme)
						-- vim.cmd.colorscheme(theme)
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>f", fzf.files, { desc = "Fzf Find Files" })
		vim.keymap.set("n", "<leader>s", fzf.live_grep, { desc = "Fzf Live Grep" })
		-- vim.keymap.set("n", "<leader>c", fzf.colorschemes, { desc = "Fzf Change Theme" })
	end,
}
