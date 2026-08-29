-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awesome = awesome

-- Standard awesome library
local awful = require("awful")
-- Notification library
local naughty = require("naughty")

-- {{{ ERROR HANDLING
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ MODULES
-- Order matters: each module depends on the ones before it.
require("awful.autofocus")
require("variables") -- theme, terminal, editor, modkey, layouts
require("menu")      -- main menu + launcher
require("keys")      -- global/client keybindings, root mouse bindings
require("rules")     -- client rules
require("signals")   -- client/screen signals, titlebars, borders
require("widgets")   -- per-screen wibox widgets
-- }}}

-- {{{ AUTOSTART
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
-- }}}