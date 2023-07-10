-- This widget is originally done by streetturtle at
-- https://github.com/streetturtle/awesome-wm-widgets
--
-- I modified it by removing features I didn't want and giving features
-- I wanted, such as click outside to hide and opacity.

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local wrapper = require('widgets.helpers.wrapper')
local click_to_hide = require('widgets.helpers.click_to_hide')

local calendar_widget = {}

local function calendar()
    local styles = {}
    local function rounded_shape(size)
        return function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, size)
        end
    end

    local calendar_theme = {
        bg = beautiful.notification_bg,
        fg = beautiful.notification_fg,
        focus_date_bg = beautiful.notification_fg,
        focus_date_fg = beautiful.notification_bg,
        weekend_day_fg = beautiful.fg_focus,
        weekday_fg = beautiful.fg_normal,
        header_fg = beautiful.fg_normal,
        border = beautiful.notificiation_border_color,
    }

    styles.month = {
        padding = 4,
        bg_color = calendar_theme.bg,
        border_width = 0,
    }

    styles.normal = {
        markup = function(t)
            return t
        end,
        shape = rounded_shape(4),
    }

    styles.focus = {
        fg_color = calendar_theme.focus_date_fg,
        bg_color = calendar_theme.focus_date_bg,
        markup = function(t)
            return '<b>' .. t .. '</b>'
        end,
        shape = rounded_shape(4),
    }

    styles.header = {
        fg_color = calendar_theme.header_fg,
        bg_color = calendar_theme.bg,
        markup = function(t)
            return '<b>' .. t .. '</b>'
        end,
    }

    styles.weekday = {
        fg_color = calendar_theme.weekday_fg,
        bg_color = calendar_theme.bg,
        markup = function(t)
            return '<b>' .. t .. '</b>'
        end,
    }

    local function decorate_cell(widget, flag, date)
        if flag == 'monthheader' and not styles.monthheader then
            flag = 'header'
        end

        -- Initiate cell colors with non-weekends non-today colors
        local final_bg = 'none'
        local final_fg = calendar_theme.fg

        -- highlight only today's day
        if flag == 'focus' then
            local today = os.date('*t')
            if not (today.month == date.month and today.year == date.year) then
                flag = 'normal'
            end
        end
        local props = styles[flag] or {}
        if props.markup and widget.get_text and widget.set_markup then
            widget:set_markup(props.markup(widget:get_text()))
        end

        -- Mark and color weekends
        local d = {
            year = date.year,
            month = (date.month or 1),
            day = (date.day or 1),
        }
        local weekday = tonumber(os.date('%w', os.time(d)))
        local is_weekend = (weekday == 0 or weekday == 6)
        if is_weekend then
            final_fg = calendar_theme.weekend_day_fg
        end

        -- Change bg and fg color to highlight today
        if flag == 'focus' then
            final_bg = calendar_theme.focus_date_bg
            final_fg = calendar_theme.focus_date_fg
            if is_weekend then
                final_bg = calendar_theme.weekend_day_fg
            end
        end

        local ret = wibox.widget({
            {
                {
                    widget,
                    halign = 'center',
                    widget = wibox.container.place,
                },
                margins = (props.padding or 2) + (props.border_width or 0),
                widget = wibox.container.margin,
            },
            shape = props.shape,
            shape_border_color = props.border_color,
            shape_border_width = props.border_width,
            fg = final_fg,
            bg = final_bg,
            widget = wibox.container.background,
        })

        return ret
    end

    local cal = wibox.widget({
        date = os.date('*t'),
        font = beautiful.get_font(),
        fn_embed = decorate_cell,
        long_weekdays = true,
        start_sunday = true,
        widget = wibox.widget.calendar.month,
    })

    local popup = awful.popup({
        ontop = true,
        visible = false,
        shape = rounded_shape(8),
        offset = { y = 50 },
        border_width = 0,
        border_color = calendar_theme.border,
        bg = calendar_theme.bg,
        widget = cal,
    })

    popup:buttons(
        awful.util.table.join(
            awful.button({}, 4, function() -- Next month
                local a = cal:get_date()
                a.month = a.month - 1
                cal:set_date(nil)
                cal:set_date(a)
                popup:set_widget(cal)
            end),
            awful.button({}, 5, function() -- Prev month
                local a = cal:get_date()
                a.month = a.month + 1
                cal:set_date(nil)
                cal:set_date(a)
                popup:set_widget(cal)
            end)
        )
    )

    function calendar_widget.toggle()
        if popup.visible then
            -- to faster render the calendar refresh it and just hide
            cal:set_date(nil) -- the new date is not set without removing the old one
            cal:set_date(os.date('*t'))
            popup:set_widget(nil) -- just in case
            popup:set_widget(cal)
            popup.visible = not popup.visible
        else
            awful.placement.top(
                popup,
                { margins = { top = 50 }, parent = awful.screen.focused() }
            )
            popup.visible = true
        end
    end

    click_to_hide.popup(popup, calendar_widget.toggle)

    return calendar_widget
end

local textclock = wibox.widget.textclock()
calendar()
textclock:connect_signal('button::press', function(_, _, _, button)
    if button == 1 then
        calendar_widget.toggle()
    end
end)

return wrapper(textclock)
