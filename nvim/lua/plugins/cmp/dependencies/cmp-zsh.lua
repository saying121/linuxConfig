return {
    "tamago324/cmp-zsh",
    cond = function()
        if vim.bo.ft == "zsh" then
            return true
        end
        return false
    end,
    dependencies = "Shougo/deol.nvim",
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("zsh", {
            sources = cmp.config.sources({
                { name = "zsh" },
                { name = "luasnip" },
                { name = "path" },
                { name = "rg", keyword_length = 4 },
            }, {
                { name = "buffer" },
            }, {
                { name = "spell" },
            }),
        })
        require("cmp_zsh").setup({
            zshrc = true, -- Source the zshrc (adding all custom completions). default: false
            filetypes = { "deoledit", "zsh" }, -- Filetypes to enable cmp_zsh source. default: {"*"}
        })
    end,
}
