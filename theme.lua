local theme_assets = require('beautiful.theme_assets')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()

local hex_digits = {
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
}

local unit_to_hex = function(num)
    local first_digit = math.floor((num * 255) / 16)
    local second_digit = math.floor((num * 255) % 16)
    return hex_digits[second_digit + 1] .. hex_digits[first_digit + 1]
end

local theme = {}

-- Colorscheme
-- TokyoNight_Night
theme.bg_color = '#1a1b26'
theme.fg_color = '#c0caf5'
theme.high_1 = '#73daca'
theme.high_2 = '#7dcfff'
theme.high_3 = '#9ece6a'
theme.high_4 = '#e0af68'
theme.low_1 = '#bb9af7'
theme.low_2 = '#f7768e'
theme.low_3 = '#7aa2f7'
theme.low_4 = '#414868'

theme.highlight = '#ffffff15'

theme.bg_opacity = 0.8
theme.useless_gap = dpi(8)
theme.gap_single_client = true

theme.font_size = '14'
theme.font_family = 'TerminessTTF Nerd Font'
theme.font = theme.font_family .. ' ' .. theme.font_size

theme.bg_normal = theme.bg_color .. unit_to_hex(theme.bg_opacity)
theme.bg_focus = theme.bg_color .. unit_to_hex(theme.bg_opacity)
theme.bg_urgent = theme.bg_color .. unit_to_hex(theme.bg_opacity)
theme.bg_minimize = theme.bg_color .. unit_to_hex(theme.bg_opacity)
theme.bg_systray = theme.bg_color .. unit_to_hex(theme.bg_opacity)

theme.fg_normal = theme.fg_color
theme.fg_focus = theme.high_1
theme.fg_urgent = theme.low_2
theme.fg_minimize = theme.fg_color

theme.border_width = 0
theme.border_normal = theme.low_4
theme.border_focus = theme.high_2
theme.border_marked = theme.low_1

theme.menu_submenu_icon = themes_path .. 'default/submenu.png'
theme.menu_width = dpi(200)
theme.menu_height = dpi(25)
theme.menu_border_color = theme.border_normal
theme.menu_border_width = 1

theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_color = theme.border_normal
theme.notification_border_width = 1

theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_modifiers_fg = theme.low_1

theme.taglist_bg_focus = 'none'

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel =
    theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel =
    theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

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

theme.wallpaper = os.getenv('HOME') .. '/Pictures/Wallpapers/hollow-knight.jpg'

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
