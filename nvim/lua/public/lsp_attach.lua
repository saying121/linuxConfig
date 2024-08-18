local api, lsp, lspb, methods = vim.api, vim.lsp, vim.lsp.buf, vim.lsp.protocol.Methods

local M = {}

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
    -- lsp.semantic_tokens.start(bufnr, client.id)

    ---@param mode string|table
    ---@param lhs string
    ---@param rhs string|function
    local function keymap(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
    end

    keymap("n", "<leader>v", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end)

    keymap("n", "<c-k>", lspb.signature_help)

    if client.supports_method(methods.textDocument_inlayHint, { bufnr = bufnr }) then
        local _ = pcall(lsp.inlay_hint.enable, true, { bufnr = bufnr })
        keymap("n", "<leader>ih", function()
            lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end)
    end

    if client.supports_method(methods.textDocument_formatting, { bufnr = bufnr }) then
        keymap("n", "<space>f", function()
            lspb.format({
                async = true,
                bufnr = bufnr,
                filter = function(client1)
                    local reject = {
                        "lua-ls",
                        "sqls",
                    }
                    if vim.tbl_contains(reject, client1.name) then
                        return false
                    else
                        return true
                    end
                end,
            })
        end)
    end
    if client.supports_method(methods.textDocument_rangeFormatting, { bufnr = bufnr }) then
        keymap("x", "<space>f", function()
            lspb.format({ async = true })
        end)
    end

    -- shit
    local lsps = {
        "lemminx",
        "jdtls",
        "tinymist",
    }
    if vim.tbl_contains(lsps, client.name) then
        keymap({ "n", "x" }, "<space>f", function()
            lspb.format({ async = true })
        end)
    end

    if client.supports_method(methods.textDocument_documentHighlight, { bufnr = bufnr }) then
        local group_name = "LspDocumentHighlight"
        api.nvim_create_augroup(group_name, { clear = false })
        api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
        api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group_name,
            buffer = bufnr,
            callback = lspb.document_highlight,
        })
        api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group_name,
            buffer = bufnr,
            callback = lspb.clear_references,
        })
    end

    if client.supports_method(methods.codeLens_resolve, { bufnr = bufnr }) then
        local group_name = "LspCodeLensRefresh"
        api.nvim_create_augroup(group_name, { clear = false })
        api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
        api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = group_name,
            buffer = bufnr,
            callback = function()
                lsp.codelens.refresh({ bufnr = bufnr })
            end,
        })
    end

    -- diagnostic
    keymap("n", "<space>e", function()
        local _, winid = vim.diagnostic.open_float({ source = true, scope = "cursor" })
        if winid then
            api.nvim_set_current_win(winid)
        end
    end)
    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function(ev)
            local f_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = "",
                scope = "cursor",
            }
            local ft = {
                "markdown",
                "python",
                "rust",
            }
            if vim.tbl_contains(ft, vim.bo.filetype) then
                return
            end
            vim.diagnostic.open_float(f_opts)
            -- api.nvim_win_close(win_id, force)
        end,
    })
end

M.capabilities = lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

return M
