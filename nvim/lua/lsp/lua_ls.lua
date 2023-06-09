---@diagnostic disable-next-line: missing-parameter
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

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
                -- 让lsp可以补全部分插件参数
                -- library = vim.api.nvim_get_runtime_file("", true),
                -- maxPreload=2000,
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
