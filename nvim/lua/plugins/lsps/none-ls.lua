---@type LazySpec
return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- cond = false,
    config = function()
        local null_ls = require("null-ls")

        local sources_table = {
            -- null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.code_actions.refactoring,
            null_ls.builtins.code_actions.gitrebase,
            null_ls.builtins.diagnostics.sqruff.with({
                filetypes = { "sql", "mysql" },
            }),
            null_ls.builtins.formatting.sqruff.with({
                filetypes = { "sql", "mysql" },
            }),
            null_ls.builtins.formatting.prettier.with({
                filetypes = {
                    "vue",
                    "scss",
                    "less",
                    "html",
                    "yaml",
                    "markdown",
                    "markdown.mdx",
                    "handlebars",
                },
            }),
            null_ls.builtins.formatting.biome.with({
                filetypes = {
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "json",
                    "jsonc",
                    "css",
                    "graphql",
                },
            }),
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.shfmt.with({
                filetypes = { "sh", "bash", "zsh" },
                extra_args = { "-i", "4" },
            }),
            null_ls.builtins.formatting.asmfmt,
            null_ls.builtins.formatting.fnlfmt,

            -- null_ls.builtins.diagnostics.golangci_lint,
            -- null_ls.builtins.diagnostics.revive,
            null_ls.builtins.formatting.golines,

            null_ls.builtins.diagnostics.checkmake,
            null_ls.builtins.diagnostics.markdownlint_cli2,
            null_ls.builtins.diagnostics.vint,
            -- null_ls.builtins.diagnostics.selene,
            null_ls.builtins.diagnostics.protolint,
            null_ls.builtins.formatting.protolint,
            null_ls.builtins.diagnostics.actionlint,
            null_ls.builtins.diagnostics.codespell.with({
                -- extra_args = { "-I", cwd .. "/codespell.txt" },
                filetypes = { "gitcommit", "markdown" },
            }),
        }

        null_ls.setup({
            sources = sources_table,
        })
    end,
}
