return {
    "neovim/nvim-lspconfig",
    -- event = { "VeryLazy" },
    dependencies = {
        -- 依赖会先加载。neodev 要在 nvim-lspconfig 之前加载。
        "hrsh7th/cmp-nvim-lsp",
        require(... .. ".neodev"),
        require(... .. ".rime-ls"),
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"

        local LSP = require("public.lsp_attach")

        -- 要手动控制，就不用这个
        -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

        for _, the_file_name in pairs(file_name_list) do
            if vim.endswith(the_file_name, ".lua") then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                if lsp_name == "clangd" then
                    capabilities.offsetEncoding = { "utf-16" }
                end

                require("lspconfig")[lsp_name].setup({
                    capabilities = capabilities,
                    on_attach = LSP.on_attach,
                    flags = LSP.lsp_flags,
                    settings = require("lsp." .. lsp_name),
                })
            end
        end

        -- VeryLazy 情况要显示启动
        -- vim.cmd("LspStart")
    end,
}
