return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
        -- 依赖会先加载。neodev 要在 nvim-lspconfig 之前加载。
        "hrsh7th/cmp-nvim-lsp",
        require(... .. ".neodev"),
        -- { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"

        local LSP = require("public.lsp_attach")

        -- 要手动控制，就不用这个
        -- local language_servers = require("lspconfig").util.available_servers()

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)
        local lspconfig = require("lspconfig")

        for _, the_file_name in ipairs(file_name_list) do
            if vim.endswith(the_file_name, ".lua") then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                local capabilities = vim.tbl_deep_extend(
                    "force",
                    vim.lsp.protocol.make_client_capabilities(), -- 下面的包含了这个
                    require("cmp_nvim_lsp").default_capabilities(),
                    {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    }
                    -- , require("epo").register_cap()
                )

                if lsp_name == "clangd" then
                    capabilities = { offsetEncoding = { "utf-16" } }
                end

                local configs = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = LSP.on_attach,
                }, require("lsp." .. lsp_name))

                lspconfig[lsp_name].setup(configs)
            end
        end
    end,
}
