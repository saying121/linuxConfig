return {
    "petertriho/cmp-git",
    -- ft = "gitcommit",
    cond = function()
        local ft = {
            gitcommit = true,
            dashboard = true,
        }
        return ft[vim.bo.ft] or false
    end,
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "luasnip", priority = 1000 },
                { name = "cmp_git", priority = 900 }, -- You can specify the `cmp_git` source if you were installed it.
                { name = "path", priority = 850 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", priority = 700 },
            }, {
                { name = "spell", priority = 600 },
                { name = "rime", priority = 600 },
            }),
        })
    end,
}
