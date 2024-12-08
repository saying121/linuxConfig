---@type LazySpec
return {
    "kristijanhusak/vim-dadbod-completion",
    -- dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        vim.g.vim_dadbod_completion_mark = "[DB]"

        -- local cmp = require("cmp")
        -- cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        --     -- Set configuration for specific filetype.
        --     sources = cmp.config.sources({
        --         { name = "vim-dadbod-completion" },
        --         { name = "nvim_lsp" },
        --         { name = "luasnip" },
        --         { name = "path" },
        --     }, {
        --         { name = "buffer" },
        --     }, {
        --         { name = "spell" },
        --     }),
        -- })
    end,
}
