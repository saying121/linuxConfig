local icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "󰕳", -- 
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
    TypeParameter = "",
}
---@type LazySpec
return {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = false,
    dependencies = {
        "f3fora/cmp-spell",
        -- "hrsh7th/cmp-buffer",
        { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
        -- "hrsh7th/cmp-path",
        {
            "https://codeberg.org/FelipeLema/cmp-async-path", --[[ name = "cmp-path" ]]
        },
        "lukas-reineke/cmp-rg",
        {
            "doxnit/cmp-luasnip-choice",
            config = function()
                require("cmp_luasnip_choice").setup({
                    auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
                })
            end,
        },
        require("public.utils").req_lua_files_return_table("plugins/" .. "nvim-cmp" .. "/dependencies"),
    },
    config = function()
        local luasnip, cmp, compare = require("luasnip"), require("cmp"), require("cmp.config.compare")
        ---@type cmp.ConfigSchema
        local cmp_cfg = cmp.config

        local source_mapping = {
            buffer = "[Buf]",
            cmdline = "[Cmd]",
            git = "[Git]",
            latex_symbols = "[Latex]",
            luasnip = "[LuaSnip]",
            nvim_lsp = "[LSP]",
            -- path = "[Path]",
            async_path = "[Path]",
            rg = "[Rg]",
            spell = "[Spell]",
            ["vim-dadbod-completion"] = "[DB]",
            zsh = "[Zsh]",
            crates = "[Crates]",
            lazydev = "[LazyDev]",
            -- luasnip_choice = "[Choice]",
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
            -- { name = "luasnip_choice" },
            -- { name = "path", priority = 800 },
            { name = "async_path", priority = 800 },
        }, {
            { name = "buffer", priority = 800 },
            { name = "rg", keyword_length = 3, priority = 700 },
        }, {
            { name = "spell", priority = 600 },
        })

        ---@type cmp.ConfigSchema
        local config = {
            ---@diagnostic disable-next-line: missing-fields
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
                ---@diagnostic disable-next-line: undefined-field
                completion = cmp_cfg.window.bordered(),
                ---@diagnostic disable-next-line: undefined-field
                documentation = cmp_cfg.window.bordered(),
            },
            formatting = {
                expandable_indicator = true,
                fields = { "kind", "abbr", "menu" },
                format = function(entry, item)
                    local max_width = 50
                    item.kind = icons[item.kind]
                    item.menu = item.menu or source_mapping[entry.source.name] or ""
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
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
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
                    compare.recently_used,
                    compare.exact,
                    compare.offset,
                    -- separated-word
                    -- │         │
                    -- │         └ source2 offset: 11
                    -- └ source1 offset: 1
                    -- https://github.com/hrsh7th/nvim-cmp/issues/883#issuecomment-1094512075
                    compare.locality,
                    compare.scopes,
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

                    local replace = require('public.ra.replace_snip')
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

        cmp.setup.filetype({ "lua" }, {
            sources = cmp_cfg.sources({
                {
                    name = "luasnip",
                    priority = 1000,
                },
                {
                    name = "lazydev",
                    priority = 1000,
                },
                {
                    name = "nvim_lsp",
                    priority = 1000,
                    -- entry_filter = function(entry, ctx)
                    --     return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                    -- end,
                },
                -- { name = "path", priority = 800 },
                { name = "async_path", priority = 800 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", keyword_length = 3, priority = 700 },
            }, {
                { name = "spell", priority = 600 },
            }),
        })
    end,
}
