local api = vim.api

---@type LazySpec
return {
    "scalameta/nvim-metals",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
        local metals_config = require("metals").bare_config()
        ---@param client vim.lsp.Client
        ---@param bufnr integer
        metals_config.on_attach = function(client, bufnr)
            -- require("metals").setup_dap()
        end
        metals_config.settings = {
            useGlobalExecutable = false,
            showImplicitArguments = false,
            showImplicitConversionsAndClasses = false,
            showInferredType = true,
            superMethodLensesEnabled = false,
            autoImportBuild = "initial",
            serverProperties = {
                "-Xmx2G",
                "-Dmetals.enable-best-effort=true",
                "-XX:+UseZGC",
                "-XX:ZUncommitDelay=30",
                "-XX:ZCollectionInterval=5",
            },
            inlayHints = {
                hintsInPatternMatch = { enable = true },
                implicitArguments = { enable = false },
                implicitConversions = { enable = false },
                inferredTypes = { enable = true },
                typeParameters = { enable = false },
            },
        }
        metals_config.init_options.statusBarProvider = "off"
        metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()

        return metals_config
    end,
    config = function(self, metals_config)
        local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
        api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end,
}
