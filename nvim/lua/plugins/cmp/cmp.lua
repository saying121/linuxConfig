return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "f3fora/cmp-spell",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-rg",
        "onsails/lspkind.nvim",
        require("public.utils").get_dependencies_table("plugins/" .. "cmp" .. "/dependencies"),
    },
    config = function()
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp, compare = require("cmp"), require("cmp.config.compare")

        local lspkind = require("lspkind")
        local source_mapping = {
            buffer = "[Buf]",
            cmdline = "[Cmd]",
            cmp_git = "[Git]",
            cmp_tabnine = "[TN]",
            crates = "[Crates]",
            latex_symbols = "[Latex]",
            luasnip = "[LuaSnip]",
            nvim_lsp = "[LSP]",
            path = "[Path]",
            rg = "[Rg]",
            spell = "[Spell]",
            vim_dadbod_completion = "[DB]",
            zsh = "[Zsh]",
        }

        cmp.setup({
            matching = {
                disallow_fuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = true,
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
                    vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" }) -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    vim_item.menu = source_mapping[entry.source.name]
                    if entry.source.name == "cmp_tabnine" then
                        local detail = (entry.completion_item.labelDetails or {}).detail
                        vim_item.kind = ""
                        if detail and detail:find(".*%%.*") then
                            vim_item.kind = vim_item.kind .. " " .. detail
                        end

                        if (entry.completion_item.data or {}).multiline then
                            vim_item.kind = vim_item.kind .. " " .. "[ML]"
                        end
                    end
                    local maxwidth = 50
                    vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
                    return vim_item
                end,
            },
            -- 分级显示，上一级有补全就不会显示下一级
            sources = cmp.config.sources({
                -- 好像只有 keyword_length 起作用了, priority 需要配合 sorting
                -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                {
                    name = "luasnip",
                    -- keyword_length = 2,
                    -- trigger_characters = { "s", "n" },
                    -- Keyword_pattern = "sn",
                    priority = 1000,
                },
                { name = "nvim_lsp", keyword_length = 0, priority = 900 },
                { name = "path", priority = 800 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", keyword_length = 3, priority = 700 },
            }, {
                { name = "cmp_tabnine", priority = 850 },
                { name = "spell", priority = 600 },
                { name = "rime", priority = 600 },
            }),
            experimental = {
                ghost_text = true,
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                        -- elseif require("neogen").jumpable() then -- 好像用 luasnip 的就行
                        --     require("neogen").jump_next()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                        -- elseif require("neogen").jumpable() then -- 好像用 luasnip 的就行
                        --     require("neogen").jump_prev()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-b>"] = cmp.mapping.scroll_docs(-1),
                ["<C-f>"] = cmp.mapping.scroll_docs(1),
                -- ['<C-Space>'] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Space>"] = cmp.mapping(function(fallback)
                    local entry = cmp.get_selected_entry()
                    if entry and entry.source.name == "nvim_lsp" and entry.source.source.client.name == "rime_ls" then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- ["<C-Space>"] = require("cmp_rime").mapping.toggle_menu,
                -- ["<Space>"] = require("cmp_rime").mapping.space_commit,
                -- ["<CR>"] = require("cmp_rime").mappings.confirm,

                -- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

                -- ["."] = require("cmp_rime").mapping.page_down,
                -- [","] = require("cmp_rime").mapping.page_up,
                --
                -- [";"] = require("cmp_rime").mapping["2"],
                -- ["'"] = require("cmp_rime").mapping["3"],
                -- -- 数字选词也可独立设置, 可设置1-9
                -- ["1"] = require("cmp_rime").mapping["1"],
            }),
            sorting = {
                -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                priority_weight = 1,
                -- rime-ls
                comparators = {
                    -- require("cmp.config.compare").sort_text, -- 这个放第一个, 其他的随意
                    compare.exact,
                    compare.recently_used,
                    compare.score,
                    compare.sort_test,
                    compare.offset,
                    compare.kind,
                    compare.length,
                    compare.order,
                    require("cmp_tabnine.compare"),
                },
            },
        })

        cmp.setup.filetype("toml", {
            sources = cmp.config.sources({
                { name = "luasnip", priority = 1000 },
                { name = "nvim_lsp", keyword_length = 0, priority = 900 },
                { name = "cmp_tabnine", priority = 850 },
                { name = "path", priority = 830 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", keyword_length = 4, priority = 700 },
            }, {
                { name = "spell", priority = 600 },
                { name = "rime", priority = 600 },
            }),
        })

        vim.opt.spell = true
        vim.opt.spelllang = { "en_us" }
    end,
}
