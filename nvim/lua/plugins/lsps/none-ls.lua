return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- cond = false,
    config = function()
        local null_ls = require("null-ls")
        local sources_table = {
            null_ls.builtins.diagnostics.sqlfluff.with({
                filetypes = { "sql", "mysql" },
            }),
            null_ls.builtins.formatting.sqlfluff.with({
                filetypes = { "sql", "mysql" },
            }),
            null_ls.builtins.formatting.typstfmt,
            null_ls.builtins.formatting.latexindent,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.shfmt.with({
                extra_args = { "-i", "4" },
            }),
            null_ls.builtins.formatting.asmfmt,
            null_ls.builtins.formatting.fnlfmt,
            null_ls.builtins.diagnostics.vint,
            -- null_ls.builtins.diagnostics.protolint,
            -- null_ls.builtins.formatting.protolint,
            null_ls.builtins.formatting.beautysh.with({
                extra_args = { "--indent-size", "4", "-s", "paronly" },
            }),
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.actionlint,
            -- null_ls.builtins.diagnostics.codespell,
        }

        null_ls.setup({
            sources = sources_table,
            on_attach = function(server, buffnr)
                vim.keymap.set({ "n", "x" }, "<space>f", function()
                    vim.lsp.buf.format({ async = true, bufnr = buffnr })
                end, { noremap = true, silent = true })
            end,
        })
    end,
}
