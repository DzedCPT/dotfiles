local wezterm = require("wezterm")
-- https://wezfurlong.org/wezterm/config/lua/config/window_decorations.html

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end
function kanagawa_colors(variant)
	if variant == "dragon" then
		return {
			foreground = "#c5c9c5",
			background = "#181616",

			-- Make the cursor some crazy colour to make  it easier to find
			-- If you want to revert the original theme make it: "#c8c093",
			cursor_bg = "#41FDFE",
			cursor_fg = "#c8c093",
			cursor_border = "#c8c093",

			selection_fg = "#c8c093",
			selection_bg = "#2d4f67",

			scrollbar_thumb = "#2d4f67",
			split = "#16161d",

			ansi = { "#0d0c0c", "#c4746e", "#8a9a7b", "#c4b28a", "#8ba4b0", "#a292a3", "#8ea4a2", "#C8C093" },

			brights = {
				"#a6a69c",
				"#E46876",
				"#87a987",
				"#E6C384",
				"#7FB4CA",
				"#938AA9",
				"#7AA89F",
				"#c5c9c5",
			},
			indexed = { [16] = "#b6927b", [17] = "#b98d7b" },
		}
	elseif variant == "lotus" then
		return {
			foreground = "#545464",
			background = "#f2ecbc",

			-- Make the cursor some crazy colour to make  it easier to find
			-- If you want to revert the original theme make it: "#c8c093",
			cursor_bg = "#41FDFE",
			cursor_fg = "#c8c093",
			cursor_border = "#c8c093",

			selection_fg = "#43436c",
			selection_bg = "#c9cbd1",

			scrollbar_thumb = "#c9cbd1",
			split = "#1F1F28",

			ansi = { "#1F1F28", "#c84053", "#6f894e", "#77713f", "#4d699b", "#b35b79", "#597b75", "#545464" },

			brights = { "#8a8980", "#d7474b", "#6e915f", "#836f4a", "#6693bf", "#624c83", "#5e857a", "#43436c" },

			indexed = { [16] = "#cc6d00", [17] = "#e82424" },
		}
	else
		return {
			foreground = "#dcd7ba",
			background = "#1f1f28",

			cursor_bg = "#c8c093",
			cursor_fg = "#c8c093",
			cursor_border = "#c8c093",

			selection_fg = "#c8c093",
			selection_bg = "#2d4f67",

			scrollbar_thumb = "#16161d",
			split = "#16161d",

			ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
			brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
			indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
		}
	end
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return kanagawa_colors("dragon")
	else
		return kanagawa_colors("lotus")
	end
end

config.force_reverse_video_cursor = false
config.colors = scheme_for_appearance(wezterm.gui.get_appearance())

config.font = wezterm.font("JetBrains Mono")

config.enable_tab_bar = false

-- disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

return config
