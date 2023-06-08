local awful = require('awful')
local wibox = require('wibox')
local theme = require('custom').theme
local dpi = require('beautiful').xresources.apply_dpi

local topbar = {}

topbar.create = function(s)
    local panel = awful.wibar({
        screen = s,
        position = 'top',
        ontop = true,
        height = theme.topbar_height,
        width = s.geometry.width,
    })

    panel:setup({
        expand = 'none',
        layout = wibox.layout.align.horizontal,
        require('widgets.task-list').create(s),
        require('widgets.calendar').create(s),
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(
                wibox.widget.systray(),
                dpi(5),
                dpi(5),
                dpi(5),
                dpi(5)
            ),
            require('widgets.bluetooth'),
            require('widgets.network'),
            require('widgets.battery'),
            wibox.layout.margin(
                require('widgets.layout-box'),
                dpi(5),
                dpi(5),
                dpi(5),
                dpi(5)
            ),
        },
    })

    -- hide panel when client is fullscreen
    local function change_panel_visibility(client)
        if client.screen == s then
            panel.ontop = not client.fullscreen
        end
    end

    -- connect panel visibility function to relevant signals
    client.connect_signal('property::fullscreen', change_panel_visibility)
    client.connect_signal('focus', change_panel_visibility)
end

return topbar
