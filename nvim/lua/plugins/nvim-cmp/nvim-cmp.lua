local icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "全", -- 
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
}
---@type LazySpec
return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = true,
    dependencies = {
        "f3fora/cmp-spell",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-rg",
        require("public.utils").req_lua_files_return_table("plugins/" .. "nvim-cmp" .. "/dependencies"),
    },
    config = function()
        local luasnip, cmp, compare = require("luasnip"), require("cmp"), require("cmp.config.compare")
        ---@type cmp.Config
        local cmp_cfg = cmp.config

        local source_mapping = {
            buffer = "[Buf]",
            cmdline = "[Cmd]",
            git = "[Git]",
            latex_symbols = "[Latex]",
            luasnip = "[LuaSnip]",
            nvim_lsp = "[LSP]",
            path = "[Path]",
            rg = "[Rg]",
            spell = "[Spell]",
            vim_dadbod_completion = "[DB]",
            zsh = "[Zsh]",
            fittencode = "[Fitten]",
            crates="[Crates]"
        }

        -- 分级显示，上一级有补全就不会显示下一级
        ---@diagnostic disable-next-line: undefined-field
        local sources = cmp_cfg.sources({
            {
                name = "luasnip",
                priority = 1000,
            },
            {
                name = "nvim_lsp",
                priority = 1000,
                -- entry_filter = function(entry, ctx)
                --     return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                -- end,
            },
            { name = "path", priority = 800 },
            { name = "fittencode", priority = 900 },
        }, {
            { name = "buffer", priority = 800 },
            { name = "rg", keyword_length = 3, priority = 700 },
        }, {
            { name = "spell", priority = 600 },
        })

        ---@type cmp.ConfigSchema
        local config = {
            matching = {
                disallow_fuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
                disallow_fullfuzzy_matching = false,
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp_cfg.window.bordered(),
                documentation = cmp_cfg.window.bordered(),
            },
            formatting = {
                expandable_indicator = true,
                fields = { "kind", "abbr", "menu" },
                format = function(entry, item)
                    local max_width = 50
                    item.kind = icons[item.kind]
                    item.menu = item.menu or source_mapping[entry.source.name]
                    item.menu = string.sub(item.menu, 1, max_width)
                    item.abbr = string.sub(item.abbr, 1, max_width)
                    return item
                end,
            },
            sources = sources,
            experimental = { ghost_text = true },
            preselect = cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-b>"] = cmp.mapping.scroll_docs(-1),
                ["<C-f>"] = cmp.mapping.scroll_docs(1),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<M-u>"] = cmp.mapping.abort(),
            }),
            sorting = {
                -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                priority_weight = 2,
                comparators = {
                    compare.exact,
                    compare.offset,
                    -- separated-word
                    -- │         │
                    -- │         └ source2 offset: 11
                    -- └ source1 offset: 1
                    -- https://github.com/hrsh7th/nvim-cmp/issues/883#issuecomment-1094512075
                    compare.locality,
                    compare.scopes,
                    compare.recently_used,
                    compare.length,
                    compare.kind,
                    compare.sort_text,
                    compare.score,
                    compare.order,
                },
            },
        }
        ---@type cmp.Setup
        cmp.setup(config)

        cmp.setup.filetype("c", {
            sorting = {
                -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                priority_weight = 1,
                comparators = {
                    compare.exact,
                    compare.offset,
                    compare.locality,
                    compare.scopes,
                    compare.recently_used,
                    require("clangd_extensions.cmp_scores"),
                    compare.length,
                    compare.kind,
                    compare.sort_text,
                    compare.score,
                    compare.order,
                },
            },
        })

        cmp.setup.filetype("rust", {
            snippet = {
                expand = function(args)
                    -- vim.print(args)

                    local replace = {
                        ["let"] = "let ${1:var} = ${2:expr};",
                        ["println!($0)"] = 'println!("$1"$2);$0',
                        ["print!($0)"] = 'print!("$1"$2);$0',
                        ["eprintln!($0)"] = 'eprintln!("$1"$2);$0',
                        ["eprint!($0)"] = 'eprint!("$1"$2);$0',
                        ["panic(${1:expr})$0"] = 'panic!("${1}"${2});$0',
                        ["format(${1:args})$0"] = 'format!("${1}"${2})',
                        ["format_args!($0)"] = 'format_args!("${1}"${2})',
                        ["concat_idents!($0)"] = "concat_idents!(${1})",
                        ["option_env!($0)"] = 'option_env!("${1}")',
                        ["write!($0)"] = 'write!(${1:std::io::stdout().lock()}, "${2}")?;',
                        ["writeln!($0)"] = 'writeln!(${1:std::io::stdout().lock()}, "${2}")?;',
                        ["debug_assert_eq!($0)"] = "debug_assert_eq!(${1}, ${2});",
                        ["debug_assert_ne!($0)"] = "debug_assert_ne!(${1}, ${2});",
                        ["assert!($0)"] = "assert!(${1});",
                        ["assert_eq!($0)"] = "assert_eq!(${1}, ${2});",
                        ["unsafe"] = "unsafe {\n\t${1}\n}$0",
                    }
                    local expd = luasnip.lsp_expand

                    local temp = replace[args.body]
                    if temp then
                        expd(temp)
                    else
                        expd(args.body)
                    end
                end,
            },
        })
    end,
}
