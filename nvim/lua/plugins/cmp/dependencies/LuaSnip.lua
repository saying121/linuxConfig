return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local luasnip, opts = require("luasnip"), { noremap = true, silent = true }
        local keymap = vim.keymap.set
        keymap({ "i", "s" }, "<c-s>", function()
            if luasnip.choice_active() then
                require("luasnip.extras.select_choice")()
            end
        end, opts)

        require("luasnip.loaders.from_lua").lazy_load({
            paths = "~/.config/nvim/lua/snippets",
            -- override_priority = 10000,
            -- default_priority = 10000,
        })

        require("luasnip.loaders.from_vscode").lazy_load({
            exclude = { "rust" },
            -- override_priority = 900,
            -- default_priority = 900,
        })
    end,
}
