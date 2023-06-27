local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local menubar = require('menubar')
local dpi = beautiful.xresources.apply_dpi

local defs = require('config.defs')

local wrapper = require('widgets.helpers.wrapper')

menubar.utils.terminal = defs.terminal

-- Power menu
local power_menu = require('widgets.power-menu')

-- Time widget
local calendar = require('widgets.calendar')

-- Battery widget
local battery_widget = require('widgets.battery-widget.battery')
local battery = wrapper(battery_widget({
    font = beautiful.font,
    enable_battery_warning = false,
    show_current_level = true,
}))

-- Volume widget
local volume_widget = require('widgets.volume-widget.volume')
local volume = wrapper(volume_widget({
    widget_type = 'icon_and_text',
    step = 5,
}))

-- Brightness widget
local brightness_widget = require('widgets.brightness-widget.brightness')
local brightness = wrapper(brightness_widget({
    type = 'icon_and_text',
    program = 'brightnessctl',
    percentage = true,
    step = 2,
}))

-- Tag list widget mouse controls
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ defs.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ defs.modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Tags
    awful.tag(
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        s,
        awful.layout.layouts[1]
    )
    s.mytaglist = wrapper(awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }))

    -- Run prompt
    s.mypromptbox = awful.widget.prompt()

    -- Layout box
    s.mylayoutbox = wrapper(awful.widget.layoutbox(s))
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))

    -- Topbar setup
    s.padding = awful.wibar({
        screen = s,
        height = 2 * beautiful.useless_gap,
        bg = '#00000000',
    })
    s.topbar = awful.wibar({
        screen = s,
        ontop = true,
        height = dpi(40),
        width = s.geometry.width - 4 * beautiful.useless_gap,
        y = 2 * beautiful.useless_gap,
        x = 2 * beautiful.useless_gap,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
    })
    s.topbar:setup({
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            power_menu(),
            s.mytaglist,
            s.mypromptbox,
        },
        wibox.container.place(
            calendar, -- Middle widget
            'center'
        ),
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            brightness,
            volume,
            battery,
            s.mylayoutbox,
        },
    })
end)
