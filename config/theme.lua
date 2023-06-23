local theme_assets = require('beautiful.theme_assets')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()

print(themes_path)

local theme = {}

-- Colorscheme
-- TokyoNight_Night
theme.bg_color = '#1a1b26'
theme.fg_color = '#c0caf5'
theme.color_1 = '#414868'
theme.color_2 = '#f7768e'
theme.color_3 = '#9ece6a'
theme.color_4 = '#e0af68'
theme.color_5 = '#7aa2f7'
theme.color_6 = '#bb9af7'
theme.color_7 = '#7dcfff'
theme.color_8 = '#73daca'

theme.font_size = '14'
theme.font_family = 'TerminessTTF Nerd Font'
theme.font = theme.font_family .. ' ' .. theme.font_size

theme.bg_normal = theme.bg_color
theme.bg_focus = theme.bg_color
theme.bg_urgent = theme.bg_color
theme.bg_minimize = theme.bg_color
theme.bg_systray = theme.bg_color
theme.opacity = 0.8

theme.fg_normal = theme.fg_color
theme.fg_focus = theme.color_8
theme.fg_urgent = theme.color_2
theme.fg_minimize = theme.fg_color

theme.useless_gap = dpi(8)
theme.gap_single_client = true

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel =
    theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel =
    theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. 'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path
    .. 'default/titlebar/close_normal.png'
theme.titlebar_close_button_focus = themes_path
    .. 'default/titlebar/close_focus.png'

theme.titlebar_minimize_button_normal = themes_path
    .. 'default/titlebar/minimize_normal.png'
theme.titlebar_minimize_button_focus = themes_path
    .. 'default/titlebar/minimize_focus.png'

theme.titlebar_ontop_button_normal_inactive = themes_path
    .. 'default/titlebar/ontop_normal_inactive.png'
theme.titlebar_ontop_button_focus_inactive = themes_path
    .. 'default/titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_active = themes_path
    .. 'default/titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_active = themes_path
    .. 'default/titlebar/ontop_focus_active.png'

theme.titlebar_sticky_button_normal_inactive = themes_path
    .. 'default/titlebar/sticky_normal_inactive.png'
theme.titlebar_sticky_button_focus_inactive = themes_path
    .. 'default/titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_active = themes_path
    .. 'default/titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_active = themes_path
    .. 'default/titlebar/sticky_focus_active.png'

theme.titlebar_floating_button_normal_inactive = themes_path
    .. 'default/titlebar/floating_normal_inactive.png'
theme.titlebar_floating_button_focus_inactive = themes_path
    .. 'default/titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_active = themes_path
    .. 'default/titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_active = themes_path
    .. 'default/titlebar/floating_focus_active.png'

theme.titlebar_maximized_button_normal_inactive = themes_path
    .. 'default/titlebar/maximized_normal_inactive.png'
theme.titlebar_maximized_button_focus_inactive = themes_path
    .. 'default/titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_active = themes_path
    .. 'default/titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_active = themes_path
    .. 'default/titlebar/maximized_focus_active.png'

theme.wallpaper = themes_path .. 'default/background.png'

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. 'default/layouts/fairhw.png'
theme.layout_fairv = themes_path .. 'default/layouts/fairvw.png'
theme.layout_floating = themes_path .. 'default/layouts/floatingw.png'
theme.layout_magnifier = themes_path .. 'default/layouts/magnifierw.png'
theme.layout_max = themes_path .. 'default/layouts/maxw.png'
theme.layout_fullscreen = themes_path .. 'default/layouts/fullscreenw.png'
theme.layout_tilebottom = themes_path .. 'default/layouts/tilebottomw.png'
theme.layout_tileleft = themes_path .. 'default/layouts/tileleftw.png'
theme.layout_tile = themes_path .. 'default/layouts/tilew.png'
theme.layout_tiletop = themes_path .. 'default/layouts/tiletopw.png'
theme.layout_spiral = themes_path .. 'default/layouts/spiralw.png'
theme.layout_dwindle = themes_path .. 'default/layouts/dwindlew.png'
theme.layout_cornernw = themes_path .. 'default/layouts/cornernww.png'
theme.layout_cornerne = themes_path .. 'default/layouts/cornernew.png'
theme.layout_cornersw = themes_path .. 'default/layouts/cornersww.png'
theme.layout_cornerse = themes_path .. 'default/layouts/cornersew.png'

-- Generate Awesome icon:
theme.awesome_icon =
    theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
