---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local lspconfig, LSP = require("lspconfig"), require("public.lsp_attach")

        require("lspconfig.ui.windows").default_options.border = "single"

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

                ---@type lsp.ClientConfig
                local configs = vim.tbl_deep_extend("force", {
                    on_attach = LSP.on_attach,
                }, require("lsp." .. lsp_name))

                lspconfig[lsp_name].setup(configs)
            end
        end
    end,
}
