-- {{{ KEY BINDINGS
local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local client = client
local root = root

local variables = require("variables")
local menu = require("menu")

local modkey = variables.modkey

-- Shortcut: mk(mods, key, fn, description, group) → awful.key(...)
local function mk(mods, key, fn, desc, group)
	return awful.key(mods, key, fn, { description = desc, group = group })
end

local globalkeys = gears.table.join(
	-- Media keys
	mk({}, "XF86AudioMute", function()
		os.execute("pamixer -t")
	end, "toggle mute", "media"),
	mk({}, "XF86AudioRaiseVolume", function()
		os.execute("pamixer -i 5")
	end, "raise volume", "media"),
	mk({}, "XF86AudioLowerVolume", function()
		os.execute("pamixer -d 5")
	end, "lower volume", "media"),

	-- Screenshots
	mk({}, "Print", function()
		awful.spawn(
			"scrot '%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -selection clipboard -t image/png -i $f && mv $f ~/Pictures/screenshots/'"
		)
	end, "screenshot fullscreen", "screenshot"),
	mk({ "Control" }, "Print", function()
		awful.spawn(
			"scrot -s '%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -selection clipboard -t image/png -i $f && mv $f ~/Pictures/screenshots/'"
		)
	end, "screenshot border", "screenshot"),

	-- Awesome
	mk({ modkey, "Shift" }, "t", function()
		awful.tag.viewtoggle()
	end, "toggle windows", "awesome"),
	mk({ modkey }, "s", hotkeys_popup.show_help, "show help", "awesome"),
	mk({ modkey }, "w", function()
		menu.mymainmenu:show()
	end, "show main menu", "awesome"),
	mk({ modkey, "Control" }, "r", awesome.restart, "reload awesome", "awesome"),
	mk({ modkey, "Shift" }, "q", awesome.quit, "quit awesome", "awesome"),
	mk({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, "lua execute prompt", "awesome"),

	-- Tags
	mk({ modkey }, "Left", awful.tag.viewprev, "view previous", "tag"),
	mk({ modkey }, "Right", awful.tag.viewnext, "view next", "tag"),
	mk({ modkey }, "Escape", awful.tag.history.restore, "go back", "tag"),

	-- Clients
	mk({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, "focus next by index", "client"),
	mk({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, "focus previous by index", "client"),
	mk({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, "swap with next client by index", "client"),
	mk({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, "swap with previous client by index", "client"),
	mk({ modkey }, "u", awful.client.urgent.jumpto, "jump to urgent client", "client"),
	mk({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, "go back", "client"),
	mk({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, "restore minimized", "client"),

	-- Screens
	mk({ modkey }, ".", function()
		client.focus = nil
		awful.screen.focus_relative(1)
		local c = awful.client.focus.history.get(awful.screen.focused(), 0)
		if c then
			client.focus = c
			c:raise()
		end
	end, "focus the next screen", "screen"),
	mk({ modkey }, ",", function()
		client.focus = nil
		awful.screen.focus_relative(-1)
		local c = awful.client.focus.history.get(awful.screen.focused(), 0)
		if c then
			client.focus = c
			c:raise()
		end
	end, "focus the previous screen", "screen"),

	-- Launcher
	mk({ modkey, "Shift" }, "Return", function()
		awful.spawn(variables.terminal)
	end, "open a terminal", "launcher"),
	mk({ modkey, "Shift" }, "p", function()
		menubar.show()
	end, "show the menubar", "launcher"),
	mk({ modkey }, "p", function()
		awful.spawn.with_shell("rofi -show drun -show-icons -monitor -1")
	end, "open rofi, on focused monitor", "launcher"),

	-- Layout manipulation
	mk({ modkey, "Control" }, "+", function()
		awful.tag.incgap(1)
	end, "increase gap size", "layout"),
	mk({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, "increase master width factor", "layout"),
	mk({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, "decrease master width factor", "layout"),
	mk({ modkey, "Control" }, "k", function()
		awful.client.incwfact(0.05)
	end, "increase client width factor", "layout"),
	mk({ modkey, "Control" }, "j", function()
		awful.client.incwfact(-0.05)
	end, "decrease client width factor", "layout"),
	mk({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, "increase the number of master clients", "layout"),
	mk({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, "decrease the number of master clients", "layout"),
	mk({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, "increase the number of columns", "layout"),
	mk({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, "decrease the number of columns", "layout"),
	mk({ modkey, "Control" }, "space", function()
		awful.layout.inc(1)
	end, "select next", "layout"),
	mk({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, "select previous", "layout")
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		mk({ modkey }, "#" .. i + 9, function()
			local s = awful.screen.focused()
			local tag = s.tags[i]
			if tag then
				tag:view_only()
			end
		end, "view tag #" .. i, "tag"),
		-- Toggle tag display.
		mk({ modkey, "Control" }, "#" .. i + 9, function()
			local s = awful.screen.focused()
			local tag = s.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, "toggle tag #" .. i, "tag"),
		-- Move client to tag.
		mk({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, "move focused client to tag #" .. i, "tag"),
		-- Toggle tag on focused client.
		mk({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, "toggle focused client on tag #" .. i, "tag")
	)
end

local clientkeys = gears.table.join(
	mk({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, "toggle fullscreen", "client"),
	mk({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, "close", "client"),
	mk({ modkey }, "space", awful.client.floating.toggle, "toggle floating", "client"),
	mk({ modkey }, "Return", function(c)
		if awful.client.getmaster() ~= nil then
			c:swap(awful.client.getmaster())
		end
	end, "move to master", "client"),
	mk({ modkey, "Shift" }, ".", function(c)
		c:move_to_screen(c.screen.index + 1)
	end, "move to next screen", "client"),
	mk({ modkey, "Shift" }, ",", function(c)
		c:move_to_screen(c.screen.index - 1)
	end, "move to prev screen", "client"),
	mk({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, "toggle keep on top", "client"),
	mk({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, "minimize", "client"),
	mk({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, "(un)maximize", "client"),
	mk({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, "(un)maximize vertically", "client"),
	mk({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, "(un)maximize horizontally", "client")
)

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- {{{ MOUSE BINDINGS
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		menu.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- Set keys
root.keys(globalkeys)

return {
	clientkeys = clientkeys,
	clientbuttons = clientbuttons,
}
-- }}}