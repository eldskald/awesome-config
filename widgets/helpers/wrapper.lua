local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local wrapper = function(widget)
    local shape = function()
        return function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(16))
        end
    end

    -- Background in the widget that appears when you hover over it
    local background_widget = wibox.widget({
        {
            widget,
            left = dpi(8),
            right = dpi(8),
            top = dpi(4),
            bottom = dpi(4),
            widget = wibox.container.margin,
        },
        bg = '#ffffff00',
        shape = shape(),
        widget = wibox.container.background,
    })

    background_widget:connect_signal('mouse::enter', function()
        background_widget:set_bg('#ffffff15')
    end)

    background_widget:connect_signal('mouse::leave', function()
        background_widget:set_bg('#ffffff00')
    end)

    -- Margins for the background containers
    return wibox.widget({
        background_widget,
        margins = dpi(4),
        widget = wibox.container.margin,
    })
end

return wrapper
