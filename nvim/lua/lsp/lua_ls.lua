return {
    settings = {
        Lua = {
            completion = {
                -- callSnippet = "Both",
                callSnippet = "Replace",
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
            workspace = {
                checkThirdParty = false,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
            hint = {
                enable = true,
            },
        },
    },
}
