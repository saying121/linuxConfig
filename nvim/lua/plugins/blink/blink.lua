local api = vim.api

---@type LazySpec
return {
    "saghen/blink.cmp",
    cond = true,
    lazy = false, -- lazy loading handled internally
    -- use a release tag to download pre-built binaries
    version = "v0.10",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "super-tab",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<A-u>"] = { "hide" },
            ["<C-y>"] = { "select_and_accept" },

            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<CR>"] = { "accept", "fallback" },

            ["<Tab>"] = {
                "select_next",
                "snippet_forward",
                "fallback",
            },
            ["<S-Tab>"] = {
                "select_prev",
                "snippet_backward",
                "fallback",
            },
        },
        snippets = {
            preset = "luasnip",
            -- Function to use when expanding LSP provided snippets
            expand = function(snippet)
                -- vim.snippet.expand(snippet)
                local luasnip = require("luasnip")

                local replace = require("public.ra.replace_snip")
                local expand = luasnip.lsp_expand

                local temp = replace[snippet]
                if temp then
                    expand(temp)
                else
                    expand(snippet)
                end
            end,
        },
        completion = {
            trigger = {
                -- When false, will not show the completion window automatically when in a snippet
                show_in_snippet = true,
                -- When true, will show the completion window after typing a character that matches the `keyword.regex`
                show_on_keyword = true,
                -- When true, will show the completion window after typing a trigger character
                show_on_trigger_character = true,
                -- LSPs can indicate when to show the completion window via trigger characters
                -- however, some LSPs (i.e. tsserver) return characters that would essentially
                -- always show the window. We block these by default.
                show_on_blocked_trigger_characters = { " ", "\n", "\t" },
                -- When both this and show_on_trigger_character are true, will show the completion window
                -- when the cursor comes after a trigger character after accepting an item
                show_on_accept_on_trigger_character = true,
                -- When both this and show_on_trigger_character are true, will show the completion window
                -- when the cursor comes after a trigger character when entering insert mode
                show_on_insert_on_trigger_character = true,
                -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
                -- the completion window when the cursor comes after a trigger character when
                -- entering insert mode/accepting an item
                show_on_x_blocked_trigger_characters = { "'", '"', "(" },
            },
            ---@diagnostic disable-next-line: missing-fields
            menu = {
                enabled = true,
                min_width = 20,
                max_height = 30,
                border = "rounded",
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", gap = 1 },
                        { "source_name" },
                    },
                    components = {
                        label = {
                            width = { max = 70 },
                            text = require("colorful-menu").blink_components_text,
                            highlight = require("colorful-menu").blink_components_highlight,
                        },
                    },
                },
            },
            documentation = {
                -- Controls whether the documentation window will automatically show when selecting a completion item
                auto_show = true,
                -- Delay before showing the documentation window
                auto_show_delay_ms = 50,
                -- Delay before updating the documentation window when selecting a new item,
                -- while an existing item is still visible
                update_delay_ms = 50,
                -- Whether to use treesitter highlighting, disable if you run into performance issues
                treesitter_highlighting = true,
                ---@diagnostic disable-next-line: missing-fields
                window = {
                    min_width = 10,
                    max_width = 60,
                    max_height = 20,
                    border = "rounded",
                    winblend = 0,
                    -- Note that the gutter will be disabled when border ~= 'none'
                    scrollbar = true,
                },
            },
            -- Displays a preview of the selected item on the current line
            ghost_text = {
                enabled = true,
            },
        },
        -- Experimental signature help support
        signature = {
            enabled = false,
            trigger = {
                blocked_trigger_characters = {},
                blocked_retrigger_characters = {},
                -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
                show_on_insert_on_trigger_character = true,
            },
            window = {
                min_width = 1,
                max_width = 100,
                max_height = 10,
                border = "padded",
                winblend = 0,
                scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
                -- Disable if you run into performance issues
                treesitter_highlighting = true,
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "ripgrep", "spell" },
            per_filetype = {
                lua = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep", "spell" },
                gitcommit = { "snippets", "buffer", "path", "git", "ripgrep", "spell" },
                markdown = { "lsp", "path", "snippets", "buffer", "ripgrep", "spell", "git" },
                octo = { "lsp", "path", "snippets", "buffer", "ripgrep", "spell", "git" },
                ["dap-repl"] = { "dap" },

                sql = { "dadbod", "lsp", "snippets", "buffer" },
                mysql = { "dadbod", "lsp", "snippets", "buffer" },
                plsql = { "dadbod", "lsp", "snippets", "buffer" },
                DressingInput = { "path", "ripgrep" },
            },
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    enabled = true,
                    transform_items = function(_, items)
                        for _, item in ipairs(items) do
                            if
                                item.kind == require("blink.cmp.types").CompletionItemKind.Snippet
                                and item.filterText == "let"
                            then
                                item.score_offset = item.score_offset + 1
                            end
                        end

                        return items
                        -- return vim.tbl_filter(function(item)
                        --     return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
                        -- end, items)
                    end,
                    should_show_items = true, -- Whether or not to show the items
                    max_items = nil, -- Maximum number of items to display in the menu
                    min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
                    fallbacks = { "buffer", "lazydev" }, -- If any of these providers return 0 items, it will fallback to this provider
                    score_offset = 0, -- Boost/penalize the score of the items
                    override = nil, -- Override the source's functions
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = 0,

                    -- For `snippets.preset == 'luasnip'`
                    opts = {
                        -- Whether to use show_condition for filtering snippets
                        use_show_condition = true,
                        -- Whether to show autosnippets in the completion list
                        show_autosnippets = true,
                    },
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 3,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = false,
                    },
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    fallbacks = { "ripgrep", "spell" },
                    -- prefix_min_len = 4,
                    opts = {
                        -- default to all visible buffers
                        get_bufnrs = function()
                            -- return vim.iter(api.nvim_list_wins())
                            return vim.iter({ api.nvim_get_current_win() })
                                :map(function(win)
                                    return api.nvim_win_get_buf(win)
                                end)
                                :filter(function(buf)
                                    return vim.bo[buf].buftype ~= "nofile"
                                end)
                                :totable()
                        end,
                    },
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                },
                dadbod = {
                    name = "Dadbod",
                    module = "vim_dadbod_completion.blink",
                    fallbacks = { "lsp" },
                },
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "Ripgrep",
                    -- the options below are optional, some default values are shown
                    ---@module "blink-ripgrep"
                    ---@type blink-ripgrep.Options
                    opts = {
                        -- For many options, see `rg --help` for an exact description of
                        -- the values that ripgrep expects.

                        -- the minimum length of the current word to start searching
                        -- (if the word is shorter than this, the search will not start)
                        prefix_min_len = 5,

                        -- The number of lines to show around each match in the preview window
                        context_size = 5,

                        -- The maximum file size that ripgrep should include in its search.
                        -- Useful when your project contains large files that might cause
                        -- performance issues.
                        -- Examples: "1024" (bytes by default), "200K", "1M", "1G"
                        max_filesize = "1M",
                        search_casing = "--smart-case",
                    },
                },
                git = {
                    name = "Git",
                    module = "blink.compat.source",
                    opts = {
                        filetypes = {
                            "gitcommit",
                            "octo",
                            "markdown",
                        },
                    },
                },
                spell = {
                    name = "Spell",
                    module = "blink-cmp-spell",
                    opts = {
                        max_entries = 10,
                        enable_in_context = function()
                            return true
                        end,
                    },
                },
                dap = {
                    name = "dap",
                    module = "blink.compat.source",
                    opts = {
                        max_entries = 10,
                        enable_in_context = function()
                            return true
                        end,
                    },
                },
            },
        },
        appearance = {
            highlight_ns = api.nvim_create_namespace("blink_cmp"),
            kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "󰒓",

                Field = "󰜢",
                Variable = "󰀫",
                Property = "󰖷",

                Class = "󰠱",
                Interface = "",
                Struct = "󱡠",
                Module = "󰕳",

                Unit = "󰪚",
                Value = "󰎠",
                Enum = "",
                EnumMember = "",

                Keyword = "󰌋",
                Constant = "󰏿",

                Snippet = "",
                Color = "󰏘",
                File = "󰈔",
                Reference = "󰬲",
                Folder = "󰉋",
                Event = "󱐋",
                Operator = "󰆕",
                TypeParameter = "",
            },
        },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
}
