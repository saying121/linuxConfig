---@diagnostic disable: undefined-doc-name
return {
    "Bekaboo/dropbar.nvim",
    cond = vim.fn.has("nvim-0.10.0") == 1,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        ---@class dropbar_configs_t
        local opts = {
            general = {
                ---@type boolean|fun(buf: integer, win: integer): boolean
                enable = function(buf, win)
                    return not vim.api.nvim_win_get_config(win).zindex
                        and vim.bo[buf].buftype == ""
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                        and not vim.wo[win].diff
                end,
                update_events = {
                    "CursorMoved",
                    "CursorMovedI",
                    "DirChanged",
                    "FileChangedShellPost",
                    "TextChanged",
                    "TextChangedI",
                    "VimResized",
                    "WinResized",
                    "WinScrolled",
                },
            },
            icons = {
                kinds = {
                    use_devicons = true,
                },
                ui = {
                    bar = {
                        separator = " ",
                        extends = "…",
                    },
                    menu = {
                        separator = " ",
                        indicator = " ",
                    },
                },
            },
            bar = {
                ---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
                sources = function(_, _)
                    local sources = require("dropbar.sources")
                    return {
                        sources.path,
                        {
                            get_symbols = function(buf, cursor)
                                if vim.bo[buf].ft == "markdown" then
                                    return sources.markdown.get_symbols(buf, cursor)
                                end
                                for _, source in ipairs({
                                    sources.lsp,
                                    sources.treesitter,
                                }) do
                                    local symbols = source.get_symbols(buf, cursor)
                                    if not vim.tbl_isempty(symbols) then
                                        return symbols
                                    end
                                end
                                return {}
                            end,
                        },
                    }
                end,
                padding = {
                    left = 1,
                    right = 1,
                },
                pick = {
                    pivots = "abcdefghijklmnopqrstuvwxyz",
                },
                truncate = true,
            },
            menu = {
                entry = {
                    padding = {
                        left = 1,
                        right = 1,
                    },
                },
                ---@type table<string, string|function|table<string, string|function>>
                ---@alias dropbar_menu_win_config_opts_t any|fun(menu: dropbar_menu_t):any
                ---@type table<string, dropbar_menu_win_config_opts_t>
                ---@see vim.api.nvim_open_win
                win_configs = {
                    border = "single",
                    style = "minimal",
                    row = function(menu)
                        return menu.parent_menu
                                and menu.parent_menu.clicked_at
                                and menu.parent_menu.clicked_at[1] - vim.fn.line("w0")
                            or 1
                    end,
                    col = function(menu)
                        return menu.parent_menu and menu.parent_menu._win_configs.width or 0
                    end,
                    relative = function(menu)
                        return menu.parent_menu and "win" or "mouse"
                    end,
                    win = function(menu)
                        return menu.parent_menu and menu.parent_menu.win
                    end,
                    height = function(menu)
                        return math.max(
                            1,
                            math.min(
                                #menu.entries,
                                vim.go.pumheight ~= 0 and vim.go.pumheight or math.ceil(vim.go.lines / 4)
                            )
                        )
                    end,
                    width = function(menu)
                        local min_width = vim.go.pumwidth ~= 0 and vim.go.pumwidth or 8
                        if vim.tbl_isempty(menu.entries) then
                            return min_width
                        end
                        return math.max(
                            min_width,
                            math.max(unpack(vim.tbl_map(function(entry)
                                return entry:displaywidth()
                            end, menu.entries)))
                        )
                    end,
                },
            },
            sources = {
                path = {
                    ---@type string|fun(buf: integer): string
                    relative_to = function(_)
                        return vim.fn.getcwd()
                    end,
                    ---Can be used to filter out files or directories
                    ---based on their name
                    ---@type fun(name: string): boolean
                    filter = function(_)
                        return true
                    end,
                },
                lsp = {
                    request = {
                        -- Times to retry a request before giving up
                        ttl_init = 60,
                        interval = 1000, -- in ms
                    },
                },
                markdown = {
                    parse = {
                        -- Number of lines to update when cursor moves out of the parsed range
                        look_ahead = 200,
                    },
                },
            },
        }
        -- require("dropbar").setup(opts)
    end,
}
