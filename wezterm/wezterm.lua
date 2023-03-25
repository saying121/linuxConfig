local wezterm = require("wezterm")
local act = wezterm.action

local tabbar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    -- background = "#000000",
    background = "#D8BFD8",
    -- background = "#909090",
    -- The active tab is the one that has focus in the window
    active_tab = {
        -- The color of the background area for the tab
        bg_color = "#2b2042",
        -- The color of the text for the tab
        fg_color = "#c0c0c0",
        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",
        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",
        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,
        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
    },
    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
    },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
    },
    -- The new tab button that let you create new tabs
    new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
    },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
    },
}

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
    default_cursor_style = 'SteadyBar', -- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.

    -- colors = { tab_bar = tabbar },
    keys = {
        { key = "k", mods = "SHIFT|CTRL", action = act.ScrollByLine(-1) },
        { key = "j", mods = "SHIFT|CTRL", action = act.ScrollByLine(1) },
        {
            key = "F12",
            -- mods = "SHIFT|CTRL",
            action = wezterm.action.ToggleFullScreen,
        },
        { key = "Enter", mods = "ALT", action = act.DisableDefaultAssignment },
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
    },
}
