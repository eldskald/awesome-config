local terminal = 'wezterm'
local editor = 'nvim'

return {
    terminal = terminal,
    editor = editor,
    modkey = 'Mod4',
    web_browser = 'brave-browser',
    notes = terminal .. ' ' .. editor .. ' -c "bd"',
    code = terminal .. ' lua',
    games = 'steam',
    screenshot_tool = 'maim -s | xclip -selection clipboard -t image/png',
    theme = {
        gap = os.getenv('DE_THEME_GAP'),
        corner_radius = os.getenv('DE_THEME_CORNER_RADIUS'),
    },
}
