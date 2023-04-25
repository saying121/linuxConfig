---@diagnostic disable: unused-local
return {
    "jose-elias-alvarez/null-ls.nvim",
    cond = function()
        local ft = {
            angular = true,
            asciidoc = true,
            css = true,
            flow = true,
            graphql = true,
            html = true,
            javascript = true,
            json = true,
            jsx = true,
            less = true,
            lua = true,
            markdown = true,
            mysql = true,
            plsql = true,
            python = true,
            rust = true,
            toml = true,
            scss = true,
            sh = true,
            sql = true,
            tex = true,
            typescript = true,
            vim = true,
            vue = true,
            yaml = true,
            zsh = true,
        }

        return ft[vim.bo.ft] or false
    end,
    event = {
        "VeryLazy",
        "LspAttach",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        local sources_table = {
            null_ls.builtins.formatting.latexindent,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
            -- null_ls.builtins.formatting.sql_formatter.with({
            --     filetypes = { "sql", "mysql" },
            -- }),
            null_ls.builtins.formatting.sqlformat.with({
                filetypes = { "sql", "mysql" },
            }),
            null_ls.builtins.formatting.json_tool,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.stylua,
            -- viml
            null_ls.builtins.diagnostics.vint,
            null_ls.builtins.diagnostics.ruff,
            null_ls.builtins.diagnostics.vale,
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.beautysh,
            null_ls.builtins.diagnostics.sqlfluff.with({
                extra_args = { "--dialect", "mysql" }, -- change to your dialect
                filetypes = { "sql", "mysql" },
            }),
            -- js
            null_ls.builtins.diagnostics.eslint,
        }

        null_ls.setup({
            sources = sources_table,
            on_attach = function(server, buffnr)
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true, buffer = buffnr })
                end, { noremap = true, silent = true })
            end,
        })
    end,
}
