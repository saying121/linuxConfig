local wezterm = require("wezterm")

local get_sehll = function()
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        return { "powershell.exe" }
    else
        return { "/bin/zsh", "-l" }
    end
end

return {
    default_prog = get_sehll(),
    font = wezterm.font_with_fallback({
        "Hack Nerd Font",
        {
            family = "Noto Sans Mono CJK SC",
            -- scale = 1.1,
            -- weight = "Bold",
        },
        "Noto Serif CJK TC",
        "WenQuanYi Zen Hei Mono",
        "JetBrains Mono",
    }),
    font_size = 10.5,
    use_cap_height_to_scale_fallback_fonts = true,
    window_background_opacity = 0.85,
    window_padding = { top = 0, bottom = 0, left = 0, right = 0 },
    text_background_opacity = 1,
    use_fancy_tab_bar = true,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,
    default_cursor_style = "SteadyBar", -- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
    -- colors = { tab_bar = tabbar },
    enable_wayland = true,
    -- color_scheme = "Dracula+",
    leader = { key = "3", mods = "CTRL" },
    keys = require("keys"),
    key_tables = require("key_tables"),
}
