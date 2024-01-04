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
                globals = {
                    "vim",
                },
            },
            format = { enable = false },
            hint = {
                enable = true,
                arrayIndex = "Enable",
                await = true,
                setType = true,
            },
            semantic = { keyword = false, variable = true },
            workspace = {
                checkThirdParty = false,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
