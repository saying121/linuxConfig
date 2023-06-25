local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
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
}
return keys
