---@type LazySpec
return {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        require("lspconfig").sqls.setup({
            on_attach = function(client, bufnr)
                require("sqls").on_attach(client, bufnr)
            end,

            -- cmd = { "sqls", "-config", vim.fn.getenv("HOME") .. "/sql/config.yml" },

            settings = {
                sqls = {
                    -- connections = {
                    --     driver = "postgresql",
                    --     dataSourceName = "host=127.0.0.1 port=5432 dbname=FirstDb",
                    -- },
                },
            },
        })
    end,
}
