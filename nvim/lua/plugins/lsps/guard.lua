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
local other_ft = {
    c = "c",
    python = "py",
    lua = "lua",
    bash = "sh",
    sh = "bash",
    zsh = "zsh",
    tex = "tex",
}

local ft = vim.tbl_deep_extend("force", {}, prettier_ft, other_ft)
local my_ut = require("public.utils")
local events = my_ut.boot_event(ft)

return {
    "nvimdev/guard.nvim",
    event = events,
    config = function()
        vim.api.nvim_create_autocmd(events, {
            group = vim.api.nvim_create_augroup("GuardKeyMap", { clear = true }),
            pattern = my_ut.for_keymap_pattern(ft),
            callback = function()
                local opts, keymap = { noremap = true, silent = true, buffer = 0 }, vim.keymap.set
                keymap({ "n", "v" }, "<space>f", "<cmd>GuardFmt<CR>", opts)
            end,
        })

        local filetype = require("guard.filetype")

        filetype("c"):fmt("clang-format"):lint("clang-tidy")
        filetype("tex"):fmt({ cmd = "latexindent", args = { "-" } })
        filetype("bash"):fmt({ cmd = "shfmt", args = { "-filename", "$FILENAME" } })
        filetype("sh"):fmt({ cmd = "shfmt", args = { "-filename", "$FILENAME" } })
        -- filetype("zsh"):fmt({ cmd = "beautysh", args = { "$FILENAME" } })--:lint({ cmd = "zsh", args = { "-n", "$FILENAME" } })
        -- filetype("zsh"):lint({ cmd = "zsh", args = { "-n", "$FILENAME" } })
        filetype("python"):fmt("black")
        -- filetype("rust"):fmt("rustfmt")

        filetype("lua"):fmt({
            cmd = "stylua",
            args = { "--search-parent-directories", "-" },
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
        })
    end,
}
