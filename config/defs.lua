local terminal = 'wezterm'
local editor = 'nvim'

local defs = {
    terminal = terminal,
    editor = editor,
    modkey = 'Mod4',
    web_browser = 'brave-browser',
    notes = terminal .. ' ' .. editor .. ' -c "bd"',
    code = terminal .. ' lua',
    games = 'steam',
    screenshot_tool = 'maim -s | xclip -selection clipboard -t image/png',
    theme = {
        gap = '8',
        corner_radius = '8',
        bg_color = '#1a1b26',
        bg_opacity = '0.8',
        font_family = 'TerminessTTF Nerd Font',
        font_size = '14',
        font_color = '#c0caf5',
    },
}
return defs
