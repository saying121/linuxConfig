---@type LazySpec
return {
    "igorlfs/nvim-dap-view",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
        icons = {
            disconnect = "",
            pause = " 󱊲",
            play = " 󱊫",
            run_last = " 󱊰",
            step_back = " 󱊳",
            step_into = " 󱊭",
            step_out = " 󱊮",
            step_over = " 󱊬",
            terminate = " 󱊱",
        },
        auto_toggle = true,
        switchbuf = "newtab",
        follow_tab = true,
        help = {
            border = "double",
        },
        winbar = {
            controls = {
                enabled = true,
                buttons = {
                    "play",
                    "step_over",
                    "step_into",
                    "step_out",
                    "step_back",
                    "run_last",
                    "terminate",
                    "disconnect",
                },
            },
            default_section = "scopes",
            sections = {
                -- "console",
                "watches",
                "scopes",
                "exceptions",
                "breakpoints",
                "threads",
                "repl",
                "sessions",
                "disassembly",
            },
        },
        windows = {
            height = 0.35,
            position = "below",
            terminal = {
                width = 0.3,
                position = "left",
            },
        },
    },
}
