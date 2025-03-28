local lib = {
    vim.env.VIMRUNTIME, -- 只有nvim内置的api
}
-- vim.api.nvim_get_runtime_file("", true)

local plugins_dir = vim.fn.stdpath("data") .. "/lazy"

-- 加载所有插件太慢了
-- local load_plugins = vim.fn.readdir(plugins_dir)

local load_plugins = {
    "lazy.nvim",
    -- "trouble.nvim",
    -- "rustaceanvim",
    -- "plenary.nvim",
    -- "nvim-lspconfig",
    -- "nvim-cmp",
    -- "nvim-treesitter",
    -- "none-ls.nvim",
    -- "LuaSnip",
    -- "image.nvim",
    -- "symbol-usage.nvim",
}

for _, value in ipairs(load_plugins) do
    table.insert(lib, plugins_dir .. "/" .. value)
end

---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            completion = {
                enable = true,
                autoRequire = true,
                callSnippet = "Replace",
                displayContext = 0,
                postfix = "?",
                showWord = "Disable",
                workspaceWord = false,
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
        },
    },
}
