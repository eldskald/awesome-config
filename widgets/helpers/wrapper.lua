local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local wrapper = function(widget)
    return wibox.container.margin(
        widget,
        dpi(8),
        dpi(8),
        dpi(8),
        dpi(8)
    )
end

return wrapper
