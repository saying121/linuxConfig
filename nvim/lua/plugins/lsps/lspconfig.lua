return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"

        local lspconfig = require("lspconfig")
        -- lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
        --     -- print(vim.inspect(config))
        --     -- if config.name == "clangd" then
        --     --     -- local custom_server_prefix = "/my/custom/server/prefix"
        --     --     -- config.cmd = { custom_server_prefix .. "/bin/clangd" }
        --     -- end
        -- end)

        local LSP = require("public.lsp_attach")

        -- 列出可用 server
        -- local language_servers = require("lspconfig").util.available_servers()

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
            autostart = true,
        }, require("cmp_nvim_lsp").default_capabilities())

        for _, the_file_name in ipairs(file_name_list) do
            if vim.endswith(the_file_name, ".lua") then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                local configs = vim.tbl_deep_extend("force", {
                    on_attach = LSP.on_attach,
                }, require("lsp." .. lsp_name))

                lspconfig[lsp_name].setup(configs)
            end
        end
    end,
}
