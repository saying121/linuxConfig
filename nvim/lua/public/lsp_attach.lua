local api, lsp = vim.api, vim.lsp
local M = {}
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
---@param client lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
    -- lsp.semantic_tokens.start(bufnr, client.id)

    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    keymap("n", "<leader>v", function()
        if vim.diagnostic.is_disabled() then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end, opts)

    keymap("n", "<c-k>", lsp.buf.signature_help, opts)

    -- print(vim.inspect(client))
    local cap = client.server_capabilities
    -- print(vim.inspect(cap))

    if cap.inlayHintProvider ~= nil then
        local _ = pcall(lsp.inlay_hint.enable, bufnr, true)
        keymap("n", "<leader>ih", function()
            lsp.inlay_hint.enable(bufnr, not lsp.inlay_hint.is_enabled())
        end, opts)
    end

    if cap.documentFormattingProvider then
        keymap("n", "<space>f", function()
            lsp.buf.format({
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
        end, opts)
    end
    if cap.documentRangeFormattingProvider then
        keymap("x", "<space>f", function()
            lsp.buf.format({ async = true })
        end, opts)
    end

    if cap.documentHighlightProvider then
        local group_name = "LspDocumentHighlight"
        api.nvim_create_augroup(group_name, { clear = false })
        api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
        api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group_name,
            buffer = bufnr,
            callback = lsp.buf.document_highlight,
        })
        api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group_name,
            buffer = bufnr,
            callback = lsp.buf.clear_references,
        })
    end

    if cap.codeLensProvider ~= nil and cap.codeLensProvider.resolveProvider then
        local group_name = "LspCodeLensRefresh"
        api.nvim_create_augroup(group_name, { clear = false })
        api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
        api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = group_name,
            buffer = bufnr,
            callback = lsp.codelens.refresh,
        })
    end

    -- diagnostic
    keymap("n", "<space>e", function()
        local _, winid = vim.diagnostic.open_float({ source = true, scope = "cursor" })
        if winid then
            api.nvim_set_current_win(winid)
        end
    end, opts)
    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local d_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "cursor",
            }
            vim.diagnostic.open_float(d_opts)
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
