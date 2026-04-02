return {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "1.*",
	build = function()
		require("typst-preview").update()
	end,
	opts = {
		open_cmd = "xdg-open %s",
		dependencies_bin = {
			["tinymist"] = "tinymist",
			["websocat"] = "websocat",
		},
	},
}
