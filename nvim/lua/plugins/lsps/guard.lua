-- Angular, CSS, Flow, GraphQL, HTML, JSON, JSX, JavaScript, LESS, Markdown, SCSS, TypeScript, Vue, YAML
local prettier_ft = {
    css = "css",
    scss = "scss",
    flow = "flow",
    graphql = "graphql",
    html = "html",
    javascript = "js",
    json = "json",
    jsx = "jsx",
    less = "less",
    markdown = "md",
    md = "markdown",
    typescript = "ts",
    vue = "vue",
    yaml = "yaml",
}
-- local other_ft = {
--     c = "c",
--     python = "py",
--     py = "python",
--     lua = "lua",
--     bash = "sh",
--     sh = "bash",
--     zsh = "zsh",
--     tex = "tex",
--     rust = "rs",
--     sql = "sql",
--     latex = "tex",
--     fennel = "fnl",
-- }
local ft = {
    "css",
    "scss",
    "flow",
    "graphql",
    "html",
    "javascript",
    "json",
    "jsx",
    "less",
    "markdown",
    "typescript",
    "vue",
    "yaml",

    -- "c",
    "py",
    "python",
    "lua",
    "sh",
    -- "bash",
    "zsh",
    "tex",
    -- "rs",
    "sql",
    "mysql",
    -- "fennel",
}

-- local ft = vim.tbl_deep_extend("force", {}, prettier_ft, other_ft)
-- local my_ut = require("public.utils")
-- local events = my_ut.boot_event(ft)

return {
    "nvimdev/guard.nvim",
    dependencies = { "nvimdev/guard-collection" },
    -- ft = ft,
    keys = { { "<space>f", mode = "n" } },
    cmd = "GuardFmt",
    config = function()
        local keymap = vim.keymap.set
        keymap({ "n", "x" }, "<space>f", function()
            vim.cmd("GuardFmt")
        end)

        local filetype = require("guard.filetype")

        -- filetype("c"):fmt("clang-format"):lint("clang-tidy")
        filetype("sh, bash"):fmt({ cmd = "shfmt", args = { "-i", "4", "-filename", "$FILENAME" } })
        filetype("zsh"):fmt({ cmd = "beautysh", args = { "--indent-size", "4", "-s", "paronly", "$FILENAME" } })
        filetype("python"):fmt("isort"):append("black")

        filetype("sql, mysql"):fmt("sqlfluff"):lint("sqlfluff")
        -- :append("sqlfluff_fix"):lint("sqlfluff")

        filetype("tex, bib, plaintex"):fmt("latexindent")
        -- filetype("fennel"):fmt("fnlfmt")
        -- filetype("rust"):fmt("rustfmt")

        filetype("lua"):fmt({
            cmd = "stylua",
            args = { "--search-parent-directories", "-" },
            stdin = true,
        })
        filetype("typst"):fmt({
            cmd = "typstfmt",
            stdin = true,
        })
        filetype("asm"):fmt({
            cmd = "asmfmt",
            stdin = true,
        })

        for item, _ in pairs(prettier_ft) do
            filetype(item):fmt("prettier")
        end

        filetype("go"):fmt("lsp"):append("golines") -- :lint("golangci")

        -- call setup LAST
        require("guard").setup({
            -- the only option for the setup function
            fmt_on_save = false,
            lsp_as_default_formatter = true,
        })
    end,
}
