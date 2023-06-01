pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
local custom = require('custom')

-- Initial setup
awful.terminal = custom.default_apps.terminal
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.float,
}

-- Importing system files
require('system.errors')
require('system.clients')
require('system.keybinds')

-- Startup system
local dir = gears.filesystem.get_configuration_dir()
awful.spawn.with_shell('picom --config ' .. dir .. '/system/picom.conf')
for _, app in ipairs(custom.startup_apps) do
  awful.spawn.with_shell(app)
end
