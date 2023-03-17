local nvim_lsp = {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    keys = {
        { "<leader>rs", mode = "n" },
        { "<leader>st", mode = "n" },
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"
        vim.keymap.set({ "n", "v" }, "<leader>rs", ":LspRestart<cr>", { silent = true, noremap = true })
        vim.keymap.set({ "n", "v" }, "<leader>st", ":LspStart<cr>", { silent = true, noremap = true })

        local signs = {
            { name = "DiagnosticSignError", text = " " },
            { name = "DiagnosticSignWarn", text = " " },
            { name = "DiagnosticSignHint", text = " " },
            { name = "DiagnosticSignInfo", text = " " },
        }
        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        -- 边框
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
        })
        vim.diagnostic.config({
            virtual_text = true,
            signs = false,
            update_in_insert = true,
            underline = true,
            float = { border = "single" },
        })

        local LSP = require("plugins.lsps.lsp_attach")

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

        for _, the_file_name in pairs(file_name_list) do
            if string.sub(the_file_name, #the_file_name - 3) == ".lua" then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                local capabilities = LSP.capabilities
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
    end,
}

return nvim_lsp
