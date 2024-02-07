return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local LSP = require("public.lsp_attach")

        require("lspconfig.ui.windows").default_options.border = "single"

        -- lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
        --     -- if config.name == "clangd" then
        --     --     -- local custom_server_prefix = "/my/custom/server/prefix"
        --     --     -- config.cmd = { custom_server_prefix .. "/bin/clangd" }
        --     -- end
        -- end)

        lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
            autostart = true,
            -- capabilities = LSP.capabilities,
            capabilities = vim.tbl_deep_extend(
                "force",
                LSP.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            ),
        })

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

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
