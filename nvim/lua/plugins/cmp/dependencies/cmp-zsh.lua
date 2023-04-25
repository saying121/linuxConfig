return {
    "tamago324/cmp-zsh",
    cond = function()
        return vim.bo.ft == "zsh" or false
    end,
    lazy = true,
    dependencies = "Shougo/deol.nvim",
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("zsh", {
            sources = cmp.config.sources({
                { name = "luasnip", priority = 1000 },
                { name = "zsh", priority = 900 },
                { name = "path", priority = 800 },
            }, {
                { name = "buffer", priority = 700 },
                { name = "rg", priority = 600 },
            }, {
                { name = "spell", priority = 500 },
                { name = "rime", priority = 500 },
            }),
        })
        require("cmp_zsh").setup({
            zshrc = true, -- Source the zshrc (adding all custom completions). default: false
            filetypes = { "deoledit", "zsh" }, -- Filetypes to enable cmp_zsh source. default: {"*"}
        })
    end,
}