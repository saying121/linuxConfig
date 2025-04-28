local vfn = vim.fn

---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    config = function()
        local lspconfig, LSP = require("lspconfig"), require("public.lsp_attach")

        local configs = require("lspconfig.configs")

        if not configs.termuxls then
            configs.termuxls = {
                default_config = {
                    cmd = { "termux-language-server" },
                    filetypes = { "PKGBUILD" },
                    -- root_dir = function(fname)
                    --     return lspconfig.util.find_git_ancestor(fname)
                    -- end,
                    single_file_support = true,
                    settings = {},
                },
            }
        end

        require("lspconfig.ui.windows").default_options.border = "single"

        lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
            autostart = true,
        })

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vfn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vfn.readdir(lsp_path)

        for _, the_file_name in ipairs(file_name_list) do
            if vim.endswith(the_file_name, ".lua") then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                ---@type vim.lsp.ClientConfig
                local client_config = vim.tbl_deep_extend("force", {
                    on_attach = LSP.on_attach,
                }, require("lsp." .. lsp_name))

                lspconfig[lsp_name].setup(client_config)
            end
        end
    end,
}
