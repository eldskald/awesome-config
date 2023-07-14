local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local defs = require('config.defs')
local click_to_hide = require('widgets.helpers.click-to-hide')

local popup = awful.popup({
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    border_width = 0,
    maximum_width = 400,
    widget = {},
})

local rows = { layout = wibox.layout.fixed.vertical }

local menu_items = {
    {
        icon = ' ',
        label = 'Launch terminal',
        command = function()
            awful.spawn.with_shell(defs.terminal)
        end,
    },
    {
        icon = ' ',
        label = 'Launch web browser',
        command = function()
            awful.spawn.with_shell(defs.web_browser)
        end,
    },
    {
        icon = ' ',
        label = 'Launch file browser',
        command = function()
            awful.spawn.with_shell(defs.file_browser)
        end,
    },
    {
        icon = ' ',
        label = 'Launch text editor',
        command = function()
            awful.spawn.with_shell(defs.text_editor)
        end,
    },
    {
        icon = '󰢱 ',
        label = 'Launch lua console',
        command = function()
            awful.spawn.with_shell(defs.code)
        end,
    },
    {
        icon = '󰓓 ',
        label = 'Launch steam',
        command = function()
            awful.spawn.with_shell(defs.games)
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
        popup.visible = false
        item.command()
    end)))

    table.insert(rows, row)
end

popup:setup(rows)

click_to_hide.popup(popup, nil)

return function()
    popup.visible = not popup.visible
    popup.x = mouse.coords().x
    popup.y = mouse.coords().y
    awful.placement.no_offscreen(popup)
end
