return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    keys = {
        { ":", mode = { "n", "v", "t" } },
        { "/", mode = { "n", "v", "t" } },
        { "?", mode = { "n", "v", "t" } },
    },
    dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "f3fora/cmp-spell",
        "lukas-reineke/cmp-rg",
        require("public.merge").get_dependencies_table("cmp"),
    },
    config = function()
        local kind_icons = {
            Text = "",
            Method = "m",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "",
            Class = "",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = "",
        }

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        local cmp = require("cmp")
        local compare = require("cmp.config.compare")

        cmp.setup({
            matching = {
                disallow_fuzzy_matching = false,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = true,
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                    vim_item.menu = ({
                        buffer = "[Buf]",
                        cmdline = "[Cmd]",
                        cmp_git = "[Git]",
                        crates  = "[Crates]",
                        latex_symbols = "[Latex]",
                        luasnip = "[LuaSnip]",
                        nvim_lsp = "[LSP]",
                        path = "[Path]",
                        rg  = "[Rg]",
                        spell = "[Spell]",
                        vim_dadbod_completion = "[DB]",
                        zsh = "[Zsh]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            -- 分级显示，上一级有补全就不会显示下一级
            sources = cmp.config.sources({
                { name = "luasnip", trigger_characters = { "s", "n" } },
                { name = "nvim_lsp", keyword_length = 1 },
                { name = "path" },
            }, {
                { name = "buffer" },
                { name = "rg", keyword_length = 4 },
            }, {
                { name = "spell" },
                { name = "rime" },
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
                -- rime-ls
                comparators = {
                    -- require("cmp.config.compare").sort_text, -- 这个放第一个, 其他的随意
                    compare.sort_test,
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.recently_used,
                    compare.kind,
                    compare.length,
                    compare.order,
                },
            },
        })

        vim.opt.spell = true
        vim.opt.spelllang = { "en_us" }
    end,
}
