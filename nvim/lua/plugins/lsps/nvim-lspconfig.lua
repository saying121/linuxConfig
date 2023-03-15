-- 被注释的部分，被lspsaga.nvim和trouble.nvim取代了
return {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        -- "ray-x/lsp_signature.nvim",
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
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        -- local theopts = { noremap = true, silent = true }
        -- local keymap = vim.keymap.set
        -- keymap('n', '<space>gg', vim.diagnostic.open_float, theopts) keymap('n', '[d', vim.diagnostic.goto_prev, theopts)
        -- keymap('n', ']d', vim.diagnostic.goto_next, theopts)
        -- keymap('n', '<space>ll', vim.diagnostic.setloclist, theopts)
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

        local LSP = {}
        -- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
        LSP.on_attach = function(client, bufnr)
            -- require("lsp_signature").on_attach({}, bufnr) -- Note: add in lsp client on-attach

            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            local keymap = vim.keymap.set
            -- keymap('n', 'gD', vim.lsp.buf.declaration, bufopts)
            -- keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
            -- keymap('n', 'gi', vim.lsp.buf.implementation, bufopts)
            -- keymap('n', 'gr', vim.lsp.buf.references, bufopts)
            -- keymap('n', 'K', vim.lsp.buf.hover, bufopts)
            keymap("n", "<c-k>", vim.lsp.buf.signature_help, bufopts)
            keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
            keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
            keymap("n", "<space>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            keymap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
            -- keymap('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            -- keymap('n', '<M-cr>', vim.lsp.buf.code_action, bufopts)
            keymap("n", "<space>f", function()
                vim.lsp.buf.format({ async = true })
            end, bufopts)

            local cap = client.server_capabilities
            if cap.documentHighlightProvider then
                vim.cmd("augroup LspHighlight")
                vim.cmd("autocmd!")
                vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
                vim.cmd("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
                vim.cmd("augroup END")
            end
        end
        LSP.lsp_flags = {
            -- This is the default in Nvim 0.7+
            debounce_text_changes = 150,
        }

        -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
        LSP.capabilities = require("cmp_nvim_lsp").default_capabilities()

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
