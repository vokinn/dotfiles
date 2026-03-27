return {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "1.*",
	build = function()
		require("typst-preview").update()
	end,
	opts = {
		open_cmd = "cmd.exe /c start %s",
		dependencies_bin = {
			["tinymist"] = "tinymist",
			["websocat"] = "websocat",
		},
	},
}
