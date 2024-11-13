-- vim: tabstop=2 shiftwidth=2 expandtab

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

-- Spawn a fish shell in login mode
config.default_prog = { "/Users/charliemiller/.nix-profile/bin/fish" }

local function is_dark()
	-- wezterm.gui is not always available, depending on what
	-- environment wezterm is operating in. Just return true
	-- if it's not defined.
	if wezterm.gui then
		-- Some systems report appearance like "Dark High Contrast"
		-- so let's just look for the string "Dark" and if we find
		-- it assume appearance is dark.
		return wezterm.gui.get_appearance():find("Dark")
	end
	return true
end

if is_dark() then
	config.color_scheme = "rose-pine"
else
	-- config.color_scheme = "OneHalfLight"
	config.color_scheme = "rose-pine-dawn"
end

-- to fix the following bug: https://github.com/wez/wezterm/issues/5990#issuecomment-2305416553
config.front_end = "WebGpu"

config.font = wezterm.font_with_fallback({
	--  "Cascadia Mono",
	"JetBrains Mono",
})
config.font_size = 13

-- Slightly transparent and blurred background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.enable_scroll_bar = true
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = "RESIZE"
-- Sets the font for the window frame (tab bar)
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	font = wezterm.font({ family = "Berkeley Mono", weight = "Bold" }),
	font_size = 11,
}

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
	}
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg, bg
	if is_dark() then
		gradient_from = gradient_to:lighten(0.2)
	else
		gradient_from = gradient_to:darken(0.2)
	end

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

config.leader = { key = "a", mods = "CMD|SHIFT", timeout_milliseconds = 1000 }

-- Table mapping keypresses to actions
config.keys = {

	{ key = "d", mods = "SHIFT|CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- movement
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "LeftArrow", mods = "SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "h", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
	--
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},
	{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
	{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },

	-- Clears the scrollback and viewport, and then sends CTRL-L to ask the
	-- shell to redraw its prompt
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	move_pane("j", "Down"),
	move_pane("k", "Up"),
	move_pane("h", "Left"),
	move_pane("l", "Right"),

	{
		-- When we push LEADER + R...
		key = "r",
		mods = "LEADER",
		-- Activate the `resize_panes` keytable
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},

	{
		key = "f",
		mods = "LEADER",
		-- Present a list of existing workspaces
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
}

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

return config
