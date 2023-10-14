local function hl_and_so_on()
    for _, value in ipairs(vim.lsp.get_clients()) do
        local cap = value.server_capabilities
        if cap.documentHighlightProvider then
            for key, _ in pairs(value.attached_buffers) do
                vim.api.nvim_create_autocmd({ "CursorHold" }, {
                    group = vim.api.nvim_create_augroup("LspHighlight", { clear = true }),
                    buffer = key,
                    callback = function()
                        vim.lsp.buf.document_highlight()
                    end,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved" }, {
                    group = vim.api.nvim_create_augroup("LspHighlight1", { clear = true }),
                    buffer = key,
                    callback = function()
                        vim.lsp.buf.clear_references()
                    end,
                })
            end
        end
        if cap.codeLensProvider ~= nil and cap.codeLensProvider.resolveProvider then
            for key, _ in pairs(value.attached_buffers) do
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    group = vim.api.nvim_create_augroup("CodeLens", { clear = true }),
                    buffer = key,
                    callback = function()
                        -- vim.lsp.codelens.refresh()
                        local _ = pcall(vim.lsp.codelens.refresh)
                    end,
                })
            end
        end
    end
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = vim.api.nvim_create_augroup("LspHi", { clear = true }),
    callback = function()
        hl_and_so_on()
    end,
})

-- vim.keymap.set("n", "<leader>hl", hi)
vim.keymap.set("n", "<leader>hl", function()
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = vim.api.nvim_create_augroup("LspHighlight", { clear = true }),
        buffer = 0,
        callback = function()
            vim.lsp.buf.document_highlight()
        end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = vim.api.nvim_create_augroup("LspHighlight1", { clear = true }),
        buffer = 0,
        callback = function()
            vim.lsp.buf.clear_references()
        end,
    })
end)
