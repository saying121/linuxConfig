local ft = {
    asciidoc = "adoc",
    asciidoc1 = "asciidoc",
    css = "css",
    flow = "flow",
    graphql = "graphql",
    html = "html",
    javascript = "js",
    json = "json",
    jsx = "jsx",
    less = "less",
    lua = "lua",
    markdown = "md",
    -- mysql = "mysql",
    -- plsql = "plsql",
    python = "py",
    scss = "scss",
    sh = "sh",
    sql = "sql",
    tex = "tex",
    typescript = "ts",
    vim = "vim",
    vue = "vue",
    yaml = "yaml",
    yml = "yml",
    zsh = "zsh",
}

return {
    "nvimtools/none-ls.nvim",
    event = require("public.utils").boot_event(ft),
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
            null_ls.builtins.formatting.latexindent,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.stylua,
            -- null_ls.builtins.formatting.shfmt,
            -- viml
            null_ls.builtins.diagnostics.vint,
            -- null_ls.builtins.diagnostics.vale,
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.beautysh,
            -- js
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.actionlint,
        }

        null_ls.setup({
            sources = sources_table,
            on_attach = function(server, buffnr)
                vim.keymap.set({ "n", "x" }, "<space>f", function()
                    vim.lsp.buf.format({ async = true, buffer = buffnr })
                end, { noremap = true, silent = true })
            end,
        })
    end,
}
