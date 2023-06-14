pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
local custom = require('custom')

awful.terminal = custom.default_apps.terminal
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.float,
}

require('system.errors')
require('system.clients')
local keys = require('system.keybinds')
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

require('theme.clients')

local dir = gears.filesystem.get_configuration_dir()
awful.spawn.with_shell('picom --config ' .. dir .. '/system/picom.conf')
awful.spawn.with_shell('udiskie')
for _, app in ipairs(custom.startup_apps) do
    awful.spawn.with_shell(app)
end
