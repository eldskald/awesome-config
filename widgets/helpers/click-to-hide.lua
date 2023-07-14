-- This code was written by Grumph
-- https://bitbucket.org/grumph/home_config/src/master/.config/awesome/helpers/click_to_hide.lua
--
-- The simplest way to use it is to call it like this:
-- local mypopup = awful.popup()
-- click_to_hide(popup, nil, true)
--
-- This will cause it to close whenever you click outside.
-- If your popup needs a different function to be closed, pass it
-- as the second argument. The third argument is in case you want
-- it to close only when you click outside the popup.
--
-- NOTE: The version on this file is old, the one on the link is for
-- awesome-git only. This old version is buggy, sometimes it works, sometimes
-- it doesn't, you have to put the mouse in the widget and leave the widget
-- again to retry but the new one on awesome-git is said to work perfectly.
-- I'll change versions once I swap to arch.

local function click_to_hide(widget, hide_fct)
    only_outside = only_outside or false

    hide_fct = hide_fct or function()
        widget.visible = false
    end

    local hide = function(i)
        if i.button == 1 then
            hide_fct()
        end
    end

    widget:connect_signal('property::visible', function(w)
        if not w.visible then
            button.disconnect_signal('press', hide)
        else
            button.connect_signal('press', hide)
        end
    end)
end

local function click_to_hide_menu(menu, hide_fct)
    hide_fct = hide_fct or function()
        menu:hide()
    end

    click_to_hide(menu.wibox, hide_fct)
end

return {
    menu = click_to_hide_menu,
    popup = click_to_hide,
}
