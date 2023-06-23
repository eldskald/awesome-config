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
}

return defs
