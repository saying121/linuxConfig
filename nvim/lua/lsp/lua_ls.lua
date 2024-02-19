local lib = vim.api.nvim_get_runtime_file("", true)

-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

for index, value in ipairs(lib) do
    lib[index] = value .. "/lua"
end

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
                -- path = lib,
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
                library = lib,
                checkThirdParty = false,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
