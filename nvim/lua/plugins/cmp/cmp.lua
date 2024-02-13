return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = true,
    dependencies = {
        "f3fora/cmp-spell",
        "hrsh7th/cmp-buffer",
        "FelipeLema/cmp-async-path",
        "lukas-reineke/cmp-rg",
        require("public.utils").req_lua_files_return_table("plugins/" .. "cmp" .. "/dependencies"),
    },
    config = function()
        local function has_words_before()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp, compare = require("cmp"), require("cmp.config.compare")

        local source_mapping = {
            buffer = "[Buf]",
            cmdline = "[Cmd]",
            git = "[Git]",
            latex_symbols = "[Latex]",
            luasnip = "[LuaSnip]",
            nvim_lsp = "[LSP]",
            async_path = "[Path]",
            rg = "[Rg]",
            spell = "[Spell]",
            vim_dadbod_completion = "[DB]",
            zsh = "[Zsh]",
        }

        -- 分级显示，上一级有补全就不会显示下一级
        local sources = cmp.config.sources({
            { name = "luasnip", priority = 1000 },
            { name = "nvim_lsp", priority = 1000 },
            { name = "async_path", priority = 800 },
        }, {
            { name = "buffer", priority = 800 },
            { name = "rg", keyword_length = 3, priority = 700 },
        }, {
            { name = "spell", priority = 600 },
        })

        cmp.setup({
            matching = {
                disallow_fuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = require("lspkind").symbolic(vim_item.kind, { mode = "symbol" }) -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    vim_item.menu = source_mapping[entry.source.name]
                    -- print(vim.inspect(entry:get_completion_item()))
                    -- vim_item.menu = entry:get_completion_item().detail
                    vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
                    return vim_item
                end,
            },
            sources = sources,
            experimental = { ghost_text = true },
            preselect = cmp.PreselectMode.Item,
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- elseif luasnip.expand_or_jumpable() then
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    -- elseif has_words_before() then
                    --     cmp.complete()
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
                priority_weight = 1,
                comparators = {
                    compare.exact, -- 精准匹配
                    compare.recently_used, -- 最近用过的靠前
                    compare.kind,
                    compare.score, -- 得分高靠前
                    compare.order,
                    compare.offset,
                    compare.length, -- 短的靠前
                    compare.sort_test,
                },
            },
        })

        cmp.setup.filetype("toml", {
            sources = cmp.config.sources({
                { name = "luasnip", priority = 1000 },
                { name = "nvim_lsp", keyword_length = 0, priority = 900 },
                { name = "async_path", priority = 830 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", keyword_length = 4, priority = 700 },
            }, {
                { name = "spell", priority = 600 },
            }),
        })

        cmp.setup.filetype("c", {
            sorting = {
                -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                priority_weight = 1,
                comparators = {
                    compare.exact, -- 精准匹配
                    compare.recently_used, -- 最近用过的靠前
                    compare.kind,
                    require("clangd_extensions.cmp_scores"),
                    compare.score, -- 得分高靠前
                    compare.order,
                    compare.offset,
                    compare.length, -- 短的靠前
                    compare.sort_test,
                },
            },
        })
    end,
}
