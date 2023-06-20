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
    mysql = "mysql",
    plsql = "plsql",
    python = "py",
    scss = "scss",
    sh = "sh",
    sql = "sql",
    tex = "tex",
    typescript = "ts",
    vim = "vim",
    vue = "vue",
    yaml = "yaml",
    zsh = "zsh",
}

local events = {}

for _, value in pairs(ft) do
    table.insert(events, "UIEnter *." .. value)
    table.insert(events, "BufNew *." .. value)
end

---@diagnostic disable: unused-local
return {
    "jose-elias-alvarez/null-ls.nvim",
    event = events,
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
            -- null_ls.builtins.diagnostics.vale,
            null_ls.builtins.diagnostics.zsh,
            -- null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.formatting.beautysh.with({
                filetypes = { "zsh", "ksh", "csh" },
            }),
            null_ls.builtins.formatting.shfmt.with({
                filetypes = { "sh", "bash" },
            }),
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
