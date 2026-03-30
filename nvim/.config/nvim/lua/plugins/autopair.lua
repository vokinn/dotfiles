return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")
		local rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		autopairs.setup()

		autopairs.add_rules({
			rule("$", "$", "typst"):with_pair(cond.not_after_regex(".")),
		})
	end,
}
