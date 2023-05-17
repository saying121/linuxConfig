return {
    "petertriho/cmp-git",
    cond = function()
        return vim.bo.ft == "gitcommit" or false
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "luasnip", priority = 1000 },
                { name = "nvim_lsp", keyword_length = 0, priority = 900 },
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
