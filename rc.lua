pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')

-- Initial setup
awful.terminal = require('default_apps').terminal
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
local startup = require('startup_apps')
local dir = gears.filesystem.get_configuration_dir()
awful.spawn.with_shell('picom --config ' .. dir .. '/system/picom.conf')
for _, app in ipairs(startup) do
  awful.spawn.with_shell(app)
end
