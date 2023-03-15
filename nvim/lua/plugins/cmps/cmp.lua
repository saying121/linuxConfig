return {
    "hrsh7th/nvim-cmp",
    event = require("plugins.cmps.cmp_events"),
    keys = require("plugins.cmps.cmp_keys"),
    dependencies = {
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "f3fora/cmp-spell",
        require("plugins.cmps.LuaSnip"),
        require("plugins.cmps.cmp-rime"),
        require("plugins.cmps.nvim-autopairs"),
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

        -- local cmp_rime = require 'cmp_rime'
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
                        nvim_lsp = "[LSP]",
                        buffer = "[Buf]",
                        path = "[Path]",
                        luasnip = "[LuaSnip]",
                        spell = "[spell]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[Latex]",
                    })[entry.source.name]
                    return vim_item
                end,
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
                    elseif vim.fn.col(".") == 1 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
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
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                -- ["<C-Space>"] = require("cmp_rime").mapping.toggle_menu,
                -- ["<Space>"] = require("cmp_rime").mapping.space_commit,
                -- ["<CR>"] = require("cmp_rime").mappings.confirm,

                -- ["<C-n>"] = cmp_rime.mapping.select_next_item,
                -- ["<C-p>"] = cmp_rime.mapping.select_prev_item,
                -- 或者这样, 目前是等效的
                -- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                --
                -- ["."] = require("cmp_rime").mapping.page_down,
                -- [","] = require("cmp_rime").mapping.page_up,
                --
                -- [";"] = require("cmp_rime").mapping["2"],
                -- ["'"] = require("cmp_rime").mapping["3"],
                -- -- 数字选词也可独立设置, 可设置1-9
                -- ["1"] = require("cmp_rime").mapping["1"],
            }),
            -- 分级显示，上一级有补全就不会显示下一级
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }, {
                { name = "spell" },
                { name = "nerdfonts" },
                { name = "rime" },
            }),
            experimental = {
                ghost_text = true,
            },
            sorting = {
                -- rime-ls
                comparators = {
                    require("cmp.config.compare").sort_text, -- 这个放第一个, 其他的随意
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

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "cmdline" },
            }, {
                { name = "path" },
            }),
        })

        vim.opt.spell = true
        vim.opt.spelllang = { "en_us" }
    end,
}
