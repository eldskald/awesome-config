pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')

-- Startup system
local startup = require('startup_apps')
local dir = gears.filesystem.get_configuration_dir()
awful.spawn.with_shell('picom --config ' .. dir .. '/picom.conf')
for _,app in startup do
  awful.spawn.with_shell(app)
end
