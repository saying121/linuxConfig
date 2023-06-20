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
    enable_wayland = true,
    leader = { key = "3", mods = "CTRL" },
    keys = {
        {
            key = "h",
            mods = "CTRL|SHIFT|ALT",
            action = act.AdjustPaneSize({ "Left", 5 }),
        },
        {
            key = "j",
            mods = "CTRL|SHIFT|ALT",
            action = act.AdjustPaneSize({ "Down", 5 }),
        },
        {
            key = "k",
            mods = "CTRL|SHIFT|ALT",
            action = act.AdjustPaneSize({ "Up", 5 }),
        },
        {
            key = "l",
            mods = "CTRL|SHIFT|ALT",
            action = act.AdjustPaneSize({ "Right", 5 }),
        },
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
            key = "d",
            mods = "ALT|CTRL",
            action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
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
            mods = "ALT",
            action = act.ActivateWindowRelative(-1),
        },
        -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
        -- 选择pane 字母
        { key = "2", mods = "CTRL", action = act.PaneSelect },
        -- 选择pane 数字
        {
            key = "1",
            mods = "CTRL",
            action = act.PaneSelect({
                alphabet = "1234567890",
            }),
        },
        {
            key = "w",
            mods = "CTRL|SHIFT",
            action = wezterm.action.CloseCurrentPane({ confirm = true }),
        },
    },
}
