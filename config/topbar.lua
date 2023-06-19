local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')

local defs = require('config.defs')

menubar.utils.terminal = defs.terminal

-- Main menu widget
local main_menu = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = awful.menu({
        items = {
            {
                'Keybindings',
                function()
                    hotkeys_popup.show_help(nil, awful.screen.focused())
                end,
            },
            { 'Manual', defs.terminal .. ' -e man awesome' },
            { 'Reload', awesome.restart },
            {
                'Logout',
                function()
                    awesome.quit()
                end,
            },
            {
                'Suspend',
                function()
                    os.execute('systemctl suspend')
                end,
            },
            {
                'Restart',
                function()
                    os.execute('systemctl reboot')
                end,
            },
            {
                'Power Off',
                function()
                    os.execute('systemctl poweroff')
                end,
            },
        },
    })
})

-- Keyboard map indicator and switcher
local keyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local time = wibox.widget.textclock()

-- Create a wibox for each screen and add it
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
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal('request::activate', 'tasklist', { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Tags
    awful.tag(
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        s,
        awful.layout.layouts[1]
    )

    -- Widgets
    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
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

    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Topbar setup
    s.mywibox = awful.wibar({ position = 'top', screen = s })
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            main_menu,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            keyboardlayout,
            wibox.widget.systray(),
            time,
            s.mylayoutbox,
        },
    })
end)

