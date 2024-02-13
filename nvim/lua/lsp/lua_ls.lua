return {
    settings = {
        Lua = {
            completion = {
                enable = true,
                callSnippet = "Replace",
                displayContext = 0,
                -- keywordSnippet = "Replace",
                postfix = "?",
                -- showWord = "Disable", -- "Fallback",
            },
            runtime = {
                version = "LuaJIT",
                -- path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
                ignoredFiles = "Opened",
                ignoreDir = {},
            },
            format = { enable = false },
            hint = {
                enable = true,
                arrayIndex = "Enable",
                await = true,
                setType = true,
            },
            semantic = {
                annotation = true,
                keyword = true,
                variable = true,
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
