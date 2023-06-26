-- Original by streetturtle at
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget
--
-- I slightly modified it to add untoggling by clicking away.

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local wrapper = require('widgets.helpers.wrapper')
local click_to_hide = require('widgets.helpers.click_to_hide')

local DIR = gears.filesystem.get_configuration_dir()
local ICON_DIR = DIR .. 'widgets/power-menu/icons/'

local logout_menu_widget = wibox.widget({
    {
        {
            image = ICON_DIR .. 'power_w.svg',
            resize = true,
            widget = wibox.widget.imagebox,
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
    border_color = beautiful.border_normal,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {},
})

local function worker(user_args)
    local rows = { layout = wibox.layout.fixed.vertical }

    local args = user_args or {}

    local font = args.font or beautiful.font

    local onlogout = args.onlogout or function()
        awesome.quit()
    end
    local onlock = args.onlock
        or function()
            awful.spawn.with_shell('i3lock')
        end
    local onreboot = args.onreboot
        or function()
            awful.spawn.with_shell('reboot')
        end
    local onsuspend = args.onsuspend
        or function()
            awful.spawn.with_shell('systemctl suspend')
        end
    local onpoweroff = args.onpoweroff
        or function()
            awful.spawn.with_shell('shutdown now')
        end

    local menu_items = {
        {
            name = 'Log out',
            icon_name = 'log-out.svg',
            command = onlogout,
        },
        { name = 'Lock', icon_name = 'lock.svg', command = onlock },
        {
            name = 'Reboot',
            icon_name = 'refresh-cw.svg',
            command = onreboot,
        },
        {
            name = 'Suspend',
            icon_name = 'moon.svg',
            command = onsuspend,
        },
        {
            name = 'Power off',
            icon_name = 'power.svg',
            command = onpoweroff,
        },
    }

    for _, item in ipairs(menu_items) do
        local row = wibox.widget({
            {
                {
                    {
                        image = ICON_DIR .. item.icon_name,
                        resize = false,
                        widget = wibox.widget.imagebox,
                    },
                    {
                        text = item.name,
                        font = font,
                        widget = wibox.widget.textbox,
                    },
                    spacing = 12,
                    layout = wibox.layout.fixed.horizontal,
                },
                margins = 8,
                layout = wibox.container.margin,
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        })

        row:connect_signal('mouse::enter', function(c)
            c:set_bg('#ffffff15')
        end)
        row:connect_signal('mouse::leave', function(c)
            c:set_bg('#ffffff00')
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
            popup.visible = true
            popup:move_next_to(mouse.current_widget_geometry)
        end
    end)

    return wrapper(logout_menu_widget)
end

return worker