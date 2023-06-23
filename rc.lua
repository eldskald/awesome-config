-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local naughty = require('naughty')

local theme = require('config.defs').theme

-- Set env variables for the whole system so you can use whatever you set
-- on defs.lua on other applications like your terminal emulator and other
-- widgets, rofi, etc.
local stdlib = require('posix.stdlib')
stdlib.setenv('DE_THEME_GAP', theme.gap)
stdlib.setenv('DE_THEME_CORNER_RADIUS', theme.corner_radius)
stdlib.setenv('DE_THEME_BG_COLOR', theme.bg_color)
stdlib.setenv('DE_THEME_BG_OPACITY', theme.bg_opacity)
stdlib.setenv('DE_THEME_FONT_FAMILY', theme.font_family)
stdlib.setenv('DE_THEME_FONT_SIZE', theme.font_size)
stdlib.setenv('DE_THEME_FONT_COLOR', theme.font_color)

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = tostring(err),
        })
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
}

-- Wallpapers
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
screen.connect_signal('property::geometry', set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

-- Topbar
require('config.topbar')

-- Keybind configs
local keybinds = require('config.keybinds')
root.keys(keybinds.globalkeys)
root.buttons(keybinds.globalbuttons)

-- Client configs
require('config.clients')

-- Startup programs
local dir = gears.filesystem.get_configuration_dir()
awful.spawn.with_shell(
    'picom --config '
        .. dir
        .. '/picom.conf --corner-radius='
        .. theme.corner_radius
)
