-- Original by streetturtle at
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget
--
-- I slightly modified it to add untoggling by clicking away and it's
-- looks and position.

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local wrapper = require('widgets.helpers.wrapper')
local click_to_hide = require('widgets.helpers.click-to-hide')

local logout_menu_widget = wibox.widget({
    {
        {
            text = ' ',
            font = beautiful.font,
            align = 'center',
            widget = wibox.widget.textbox,
        },
        margins = 4,
        layout = wibox.container.margin,
    },
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
})

local popup = awful.popup({
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    border_width = 0,
    maximum_width = 400,
    widget = {},
    y = 50,
    x = 4 * beautiful.useless_gap,
})

local function worker()
    local rows = { layout = wibox.layout.fixed.vertical }

    local menu_items = {
        {
            icon = '󰍃 ',
            label = 'Log out',
            command = function()
                awesome.quit()
            end,
        },
        {
            icon = ' ',
            label = 'Lock',
            command = function()
                awful.spawn.with_shell('i3lock')
            end,
        },
        {
            icon = ' ',
            label = 'Suspend',
            command = function()
                awful.spawn.with_shell('systemctl suspend')
            end,
        },
        {
            icon = ' ',
            label = 'Reboot',
            command = function()
                awful.spawn.with_shell('reboot')
            end,
        },
        {
            icon = '󰤆 ',
            label = 'Power off',
            command = function()
                awful.spawn.with_shell('systemctl poweroff')
            end,
        },
    }

    for _, item in ipairs(menu_items) do
        local row = wibox.widget({
            {
                {
                    {
                        text = item.icon,
                        font = beautiful.font,
                        forced_width = 40,
                        align = 'center',
                        widget = wibox.widget.textbox,
                    },
                    {
                        text = item.label,
                        font = beautiful.font,
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                margins = 8,
                layout = wibox.container.margin,
            },
            bg = 'none',
            widget = wibox.container.background,
        })
        row:connect_signal('mouse::enter', function(c)
            c:set_bg(beautiful.highlight)
        end)
        row:connect_signal('mouse::leave', function(c)
            c:set_bg('none')
        end)
        local old_cursor, old_wibox
        row:connect_signal('mouse::enter', function()
            local wb = mouse.current_wibox
            old_cursor, old_wibox = wb.cursor, wb
            wb.cursor = 'hand1'
        end)
        row:connect_signal('mouse::leave', function()
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end)
        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            popup.visible = not popup.visible
            item.command()
        end)))
        table.insert(rows, row)
    end

    popup:setup(rows)

    click_to_hide.popup(popup, nil)

    logout_menu_widget:connect_signal('button::press', function(_, _, _, button)
        if button == 1 then
            popup.visible = not popup.visible
        end
    end)

    return wrapper(logout_menu_widget)
end

return worker
