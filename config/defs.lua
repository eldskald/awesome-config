local terminal = 'kitty'
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
}
