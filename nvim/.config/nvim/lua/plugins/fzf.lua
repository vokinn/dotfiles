return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			colorschemes = {
				actions = {
					["enter"] = function(selected)
						if #selected == 0 then
							return
						end

						local theme = selected[1]:match("^[^:]+")
						ColorMyPencils(theme)
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>f", fzf.files, { desc = "Fzf Find Files" })
		vim.keymap.set("n", "<leader>s", fzf.live_grep, { desc = "Fzf Live Grep" })
		vim.keymap.set("n", "<leader>c", fzf.colorschemes, { desc = "Fzf Change Theme" })
	end,
}
