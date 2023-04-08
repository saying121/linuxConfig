return {
    "petertriho/cmp-git",
    -- ft = "gitcommit",
    cond = function()
        if vim.bo.ft == "gitcommit" then
            return true
        end
        return false
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
                { name = "buffer" },
            }),
        })
    end,
}
