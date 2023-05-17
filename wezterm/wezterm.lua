local wezterm = require("wezterm")
local act = wezterm.action

local get_sehll = function()
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        return { "powershell.exe" }
    else
        return { "/bin/zsh", "-l" }
    end
end

return {
    default_prog = get_sehll(),
    font = wezterm.font("Hack Nerd Font"),
    font_size = 13,
    window_background_opacity = 0.81,
    window_padding = { top = 0, bottom = 0, left = 0, right = 0 },
    text_background_opacity = 1,
    use_fancy_tab_bar = true,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,
    default_cursor_style = "SteadyBar", -- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
    -- colors = { tab_bar = tabbar },
    keys = {
        {
            key = "k",
            mods = "SHIFT|CTRL",
            action = act.ScrollByLine(-1),
        },
        {
            key = "j",
            mods = "SHIFT|CTRL",
            action = act.ScrollByLine(1),
        },
        {
            key = "F12",
            -- mods = "SHIFT|CTRL",
            action = wezterm.action.ToggleFullScreen,
        },
        {
            key = "Enter",
            mods = "ALT",
            action = act.DisableDefaultAssignment,
        },
        {
            key = "d",
            mods = "SHIFT|CTRL",
            action = act.SpawnTab("CurrentPaneDomain"),
        },
        {
            key = "d",
            mods = "SHIFT|ALT",
            action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "{",
            mods = "SHIFT|CTRL",
            action = act.MoveTabRelative(-1),
        },
        {
            key = "}",
            mods = "SHIFT|CTRL",
            action = act.MoveTabRelative(1),
        },
        {
            key = "RightArrow",
            mods = "ALT",
            action = act.ActivateWindowRelative(1),
        },
        {
            key = "LeftArrow",
            mods = "CTRL",
            action = act.ActivateWindowRelative(-1),
        },
    },
}
