local theme = require "plugins.configs.feline.colors"

local utils = require "core.utils"
local components = require "plugins.configs.feline.components"

local statusline = {
	active = { {}, {}, {} },
	inactive = { {}, {}, {} },
}

local winbar = {
	active = { {}, {}, {} },
	inactive = { {}, {}, {} },
}

------ Statusline -----

-- Active
table.insert(statusline.active[1], components.vi_mode)
table.insert(statusline.active[1], { provider = " on", hl = { fg = "fg_dark" } })
table.insert(statusline.active[1], components.git_branch)
table.insert(statusline.active[3], components.lsp_status)
table.insert(statusline.active[3], {
	provider = " ",
	hl = function()
		return { bg = require("feline.providers.vi_mode").get_mode_color() }
	end,
})

-- Inactive
table.insert(statusline.inactive[1], {})

----- Winbar ----

-- Active
table.insert(winbar.active[1], components.file_path)
table.insert(winbar.active[1], components.git_added)
table.insert(winbar.active[1], components.git_changed)
table.insert(winbar.active[1], components.git_removed)
table.insert(winbar.active[1], { hl = { bg = "none" } })

-- Inactive
table.insert(winbar.inactive[1], components.file_path)
table.insert(winbar.inactive[1], { hl = { bg = "none" } })

------ Setup ------

require("feline").setup {
	components = statusline,
	theme = theme,
	vi_mode_colors = {
		NORMAL = "blue",
		COMMAND = "orange",
		INSERT = "red",
	},
}

require("feline").winbar.setup {
	components = winbar,
	disable = {
		filetypes = {
			"^NvimTree$",
		},
		buftypes = {
			"^terminal$",
		},
		bufnames = {},
	},
}
