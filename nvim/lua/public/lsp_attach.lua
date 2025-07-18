local api, lsp, lspb, methods = vim.api, vim.lsp, vim.lsp.buf, vim.lsp.protocol.Methods
local diagnostic = vim.diagnostic

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
        diagnostic.enable(not diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end)

    if client:supports_method(methods.textDocument_signatureHelp, bufnr) then
        keymap("n", "<c-k>", lspb.signature_help)
    end

    if client:supports_method(methods.textDocument_inlayHint, bufnr) then
        local _ = pcall(lsp.inlay_hint.enable, true, { bufnr = bufnr })
        keymap("n", "<leader>ih", function()
            lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end)
    end

    local function lsp_format()
        local reject = {
            ["lua-ls"] = true,
            sqls = true,
            jsonls = true,
            ["typescript-tools"] = true,
            vtsls = true,
            volar = true,
        }
        keymap("n", "<space>f", function()
            lspb.format({
                async = true,
                filter = function(client1)
                    if reject[client1.name] then
                        return false
                    else
                        return true
                    end
                end,
            })
        end)
    end

    if client:supports_method(methods.textDocument_formatting, bufnr) then
        lsp_format()
    end
    if
        client:supports_method(methods.textDocument_rangeFormatting, bufnr)
        or client:supports_method(methods.textDocument_rangesFormatting, bufnr)
        or client.name == "tinymist"
    then
        lsp_format()
        keymap("x", "<space>f", function()
            lspb.format({ async = true })
        end)
    end

    if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
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

    if client:supports_method(methods.codeLens_resolve, bufnr) then
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
        local _, winid = diagnostic.open_float({ source = true, scope = "cursor" })
        if winid then
            api.nvim_set_current_win(winid)
        end
    end)
end

return M
