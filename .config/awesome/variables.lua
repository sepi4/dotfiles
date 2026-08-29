-- {{{ VARIABLES
-- Themes define colours, icons, font and wallpapers.
local awful = require("awful")
local beautiful = require("beautiful")

beautiful.init("~/.config/awesome/theme.lua")

-- Default terminal and editor to run.
local terminal = "kitty" -- wezterm/alacritty/xterm
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod1" -- Alt
-- local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.max,
}
awful.layout.layouts = layouts

return {
	terminal = terminal,
	editor_cmd = editor_cmd,
	modkey = modkey,
	layouts = layouts,
}
-- }}}