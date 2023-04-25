return {
    "folke/noice.nvim",
    event = "VeryLazy",
    priority = 900,
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    background_colour = "#000000",
                    stages = "fade_in_slide_out",
                })
            end,
        },
    },
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true, -- enables the Noice cmdline UI
                view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                opts = {}, -- global options for the cmdline. See section on views
                -- format = {},
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true, -- enables the Noice messages UI
                -- view = "popup", -- default view for messages
                view = "mini", -- default view for messages
                view_error = "notify", -- view for errors
                view_warn = "mini", -- view for warnings
                view_history = "messages", -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
            },
            popupmenu = {
                enabled = true, -- enables the Noice popupmenu UI
                ---@type 'nui'|'cmp'
                backend = "nui", -- backend to use to show regular cmdline completions
                -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
                -- kind_icons = {}, -- set to `false` to disable icons
            },
            -- default options for require('noice').redirect
            -- see the section on Command Redirection
            redirect = {
                view = "popup",
                filter = { event = "msg_show" },
            },
            -- You can add any custom commands below that will be available with `:Noice command`
            commands = {
                history = {
                    -- options for the message history that you get with `:Noice`
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "popupmenu" } },
                            { event = "lsp", kind = "message" },
                        },
                    },
                },
                -- :Noice last
                last = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp", kind = "message" },
                        },
                    },
                    filter_opts = { count = 1 },
                },
                -- :Noice errors
                errors = {
                    -- options for the message history that you get with `:Noice`
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { error = true },
                    filter_opts = { reverse = true },
                },
            },
            notify = {
                -- Noice can be used as `vim.notify` so you can route any notification like other messages
                -- Notification messages have their level and other properties set.
                -- event is always "notify" and kind can be any log level as a string
                -- The default routes will forward notifications to nvim-notify
                -- Benefit of using Noice for this is the routing and consistent history view
                enabled = true,
                -- view = "popup",
                view = "notify",
            },
            lsp = {
                progress = {
                    enabled = true,
                    -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                    -- See the section on formatting for more details on how to customize.
                    format = "lsp_progress",
                    format_done = "lsp_progress_done",
                    throttle = 1000 / 30, -- frequency to update lsp progress message
                    view = "mini",
                },
                override = {
                    -- override the default lsp markdown formatter with Noice
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    -- override the lsp markdown formatter with Noice
                    ["vim.lsp.util.stylize_markdown"] = true,
                    -- override cmp documentation with Noice (needs the other options to work)
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    enabled = true,
                    view = nil, -- when nil, use defaults from documentation
                    opts = {}, -- merged with defaults from documentation
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                        throttle = 50, -- Debounce lsp signature help request by 50ms
                    },
                    view = nil, -- when nil, use defaults from documentation
                    opts = {}, -- merged with defaults from documentation
                },
                message = {
                    -- Messages shown by lsp servers
                    enabled = true,
                    view = "notify",
                    opts = {},
                },
                -- defaults for hover and signature help
                documentation = {
                    view = "hover",
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            smart_move = {
                -- noice tries to move out of the way of existing floating windows.
                enabled = true, -- you can disable this behaviour here
                -- add any filetypes here, that shouldn't trigger smart move.
                excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
            },
            presets = {
                -- you can enable a preset by setting it to true, or a table that will override the preset config
                -- you can also add custom presets that you can enable/disable with enabled=true
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
                cmdline_output_to_split = true,
            },
            views = {
                popup = {
                    backend = "popup",
                    relative = "editor",
                    close = {
                        events = { "BufLeave" },
                        keys = { "q" },
                    },
                    enter = true,
                    border = {
                        style = "rounded",
                    },
                    position = "50%",
                    size = {
                        width = "120",
                        height = "30",
                    },
                    win_options = {
                        winhighlight = { Normal = "NoicePopup", FloatBorder = "NoicePopupBorder" },
                    },
                },
            },
            routes = {
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = false },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "yanked",
                    },
                    opts = { skip = true },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "line",
                    },
                    opts = { skip = true },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "change",
                    },
                    opts = { skip = true },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "echo",
                        find = "no targets",
                    },
                    opts = { skip = false },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "info",
                    },
                    opts = { skip = false },
                },
                {
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        kind = "echo",
                        find = "Running healthchecks",
                    },
                    opts = { skip = false },
                },
                {
                    view = "popup",
                    filter = {
                        event = "msg_show",
                        kind = { "echo" },
                        find = "",
                    },
                    opts = { skip = false },
                },
            }, --- @see section on routes
        })
    end,
}
