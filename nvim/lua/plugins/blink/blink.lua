local api = vim.api
local vfn = vim.fn
local rust_replace = require("public.ra.replace_snip")
local home = vim.env.HOME

---@type LazySpec
return {
    "saghen/blink.cmp",
    cond = true,
    lazy = false, -- lazy loading handled internally
    version = "*",
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

                local temp = rust_replace.snippet[snippet]
                if temp ~= nil then
                    luasnip.lsp_expand(temp)
                else
                    luasnip.lsp_expand(snippet)
                end
            end,
        },
        cmdline = {
            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "show", "accept" },
                ["<S-Tab>"] = { "select_prev" },
                ["<Down>"] = { "select_next" },
                ["<Up>"] = { "select_prev" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-space>"] = { "show", "hide" },
                ["<A-u>"] = { "cancel" },
            },
            completion = { menu = { auto_show = true } },
        },
        completion = {
            list = {
                selection = {
                    auto_insert = false,
                    preselect = true,
                },
            },
            trigger = {
                -- When false, will not show the completion window automatically when in a snippet
                show_in_snippet = true,
                -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
                show_on_keyword = true,
                -- When true, will show the completion window after typing a trigger character
                show_on_trigger_character = true,
                -- LSPs can indicate when to show the completion window via trigger characters
                -- however, some LSPs (i.e. tsserver) return characters that would essentially
                -- always show the window. We block these by default.
                show_on_blocked_trigger_characters = function()
                    if vim.api.nvim_get_mode().mode == "c" then
                        return {}
                    end

                    return { " ", "\n", "\t" }
                end,
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
        fuzzy = {
            sorts = { "exact", "score", "sort_text" },
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
        enabled = function()
            return (vim.bo.buftype ~= "prompt" and vim.b.completion ~= false) or require("cmp_dap").is_dap_buffer()
        end,
        sources = {
            default = function()
                local default = { "lsp", "path", "snippets", "buffer", "ripgrep", "dictionary" }
                if vim.bo.ft == "lua" and string.find(vim.fn.expand("%:p"), "nvim/lua") ~= nil then
                    table.insert(default, "lazydev")
                elseif vim.bo.ft == "markdown" then
                    table.insert(default, "git")
                elseif vim.bo.ft == "bash" or vim.bo.ft == "sh" or vim.bo.ft == "zsh" then
                    table.insert(default, "env")
                end
                return default
            end,
            per_filetype = {
                gitcommit = { "snippets", "buffer", "path", "git", "ripgrep", "dictionary" },
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
                        if vim.o.filetype == "rust" then
                            ---@param item blink.cmp.CompletionItem
                            return vim.tbl_filter(function(item)
                                -- If ra have `enum`, `let` keyword and snippet only use snippet
                                return not (
                                    item.kind == require("blink.cmp.types").CompletionItemKind.Keyword
                                    and rust_replace.keyword[item.filterText]
                                )
                            end, items)
                        else
                            return items
                        end
                    end,
                    should_show_items = true,
                    max_items = nil,
                    fallbacks = { "buffer", "lazydev", "dictionary" },
                    score_offset = 0,
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = 0,
                    fallbacks = { "buffer", "dictionary" },
                    min_keyword_length = 1,
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
                        trailing_slash = true,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vfn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    fallbacks = { "ripgrep" },
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
                    min_keyword_length = 5,
                    ---@module "blink-ripgrep"
                    ---@type blink-ripgrep.Options
                    opts = {
                        prefix_min_len = 5,
                        context_size = 5,
                        max_filesize = "1M",
                        search_casing = "--smart-case",
                    },
                },
                git = {
                    name = "Git",
                    module = "blink-cmp-git",
                    score_offset = 1,
                    enabled = function()
                        if vim.o.filetype == "gitcommit" then
                            return true
                        end
                        local success, node = pcall(vim.treesitter.get_node)
                        local enable_type = {
                            comment = true,
                            line_comment = true,
                            block_comment = true,
                        }
                        if success and node ~= nil and enable_type[node:type()] then
                            return true
                        end

                        vfn.system("git rev-parse --is-inside-work-tree")
                        local g = vim.v.shell_error == 0
                        local c = vim.o.filetype == "markdown"

                        return c and g
                    end,
                },
                dictionary = {
                    min_keyword_length = 4,
                    name = "Dict",
                    module = "blink-cmp-dictionary",
                    ---@module "blink-cmp-dictionary"
                    ---@type blink-cmp-dictionary.Options
                    opts = {
                        dictionary_files = {
                            vim.fn.expand("~/.local/share/nvim/Trans/neovim.dict"),
                        },
                        separate_output = function(output)
                            local items = {}
                            for line in output:gmatch("[^\r\n]+") do
                                table.insert(items, {
                                    label = line,
                                    insert_text = line,
                                    documentation = {
                                        get_command = "sqlite3",
                                        get_command_args = {
                                            home .. "/.local/share/nvim/Trans/ultimate.db",
                                            "select translation from stardict where word = '" .. line .. "';",
                                        },
                                        ---@diagnostic disable-next-line: redefined-local
                                        resolve_documentation = function(output)
                                            print(output)
                                            return output
                                        end,
                                    },
                                })
                            end
                            return items
                        end,
                    },
                },
                dap = {
                    name = "Dap",
                    module = "blink.compat.source",
                },
                env = {
                    name = "Env",
                    module = "blink-cmp-env",
                    opts = {},
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
    -- Allows extending the enabled_providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
}
