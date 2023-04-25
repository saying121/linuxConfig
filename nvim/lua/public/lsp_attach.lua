-- 被注释的部分，被 lspsaga.nvim 和 trouble.nvim 取代了
local M = {}
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
    -- keymap("n", "gy", vim.lsp.buf.type_definition, bufopts)
    -- keymap('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- keymap('n', '<M-cr>', vim.lsp.buf.code_action, bufopts)
    keymap("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)

    -- vim-illuminate 取代了
    local cap = client.server_capabilities
    if cap.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = vim.api.nvim_create_augroup("LspHighlight", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            group = vim.api.nvim_create_augroup("LspHighlight1", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end
end

M.lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

return M
