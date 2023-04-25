return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local luasnip, opts = require("luasnip"), { noremap = true, silent = true }
        local keymap = vim.keymap.set
        -- keymap({ "i", "s" }, "<C-s>", "<Plug>luasnip-next-choice", opts)
        -- keymap({ "i", "s" }, "<C-S-s>", "<Plug>luasnip-prev-choice", opts)
        keymap({ "i", "s" }, "<c-s>", function()
            if luasnip.choice_active() then
                require("luasnip.extras.select_choice")()
            end
        end, opts)

        require("luasnip.loaders.from_vscode").lazy_load()

        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
        -- s = function() return require("luasnip.nodes.snippet").S end,
        -- sn = function() return require("luasnip.nodes.snippet").SN end,
        -- isn = function() return require("luasnip.nodes.snippet").ISN end,
        -- t = function() return require("luasnip.nodes.textNode").T end,
        -- i = function() return require("luasnip.nodes.insertNode").I end,
        -- f = function() return require("luasnip.nodes.functionNode").F end,
        -- c = function() return require("luasnip.nodes.choiceNode").C end,
        -- d = function() return require("luasnip.nodes.dynamicNode").D end,
        -- r = function() return require("luasnip.nodes.restoreNode").R end,
        -- events = function() return require("luasnip.util.events") end,
        -- ai = function() return require("luasnip.nodes.absolute_indexer") end,
        -- extras = function() return require("luasnip.extras") end,
        -- l = function() return require("luasnip.extras").lambda end,
        -- rep = function() return require("luasnip.extras").rep end,
        -- p = function() return require("luasnip.extras").partial end,
        -- m = function() return require("luasnip.extras").match end,
        -- n = function() return require("luasnip.extras").nonempty end,
        -- dl = function() return require("luasnip.extras").dynamic_lambda end,
        -- fmt = function() return require("luasnip.extras.fmt").fmt end,
        -- fmta = function() return require("luasnip.extras.fmt").fmta end,
        -- conds = function() return require("luasnip.extras.expand_conditions") end,
        -- postfix = function() return require("luasnip.extras.postfix").postfix end,
        -- types = function() return require("luasnip.util.types") end,
        -- parse = function() return require("luasnip.util.parser").parse_snippet end,
        -- ms = function() return require("luasnip.nodes.multiSnippet").new_multisnippet end,
    end,
}
