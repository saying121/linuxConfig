-- 被注释的部分，被 lspsaga.nvim 和 trouble.nvim 取代了
local M = {}
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set
    -- keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    -- keymap('n', 'gd', vim.lsp.buf.definition, opts)
    -- keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    -- keymap('n', 'gr', vim.lsp.buf.references, opts)
    -- keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap("n", "<c-k>", vim.lsp.buf.signature_help, opts)
    keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    keymap("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    -- keymap("n", "gy", vim.lsp.buf.type_definition, opts)
    -- keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- keymap('n', '<M-cr>', vim.lsp.buf.code_action, opts)
    keymap("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    -- print(vim.inspect(client))
    local cap = client.server_capabilities
    -- 取消下面的注释使用 :messages 可以查看 lsp 支持的功能
    -- print(vim.inspect(cap))

    -- inlay hints相关
    if cap.inlayHintProvider.resolveProvider then
        if vim.fn.has("nvim-0.10.0") == 1 then
            vim.lsp.buf.inlay_hint(0, true)

            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("EnableInlayHint", { clear = true }),
                callback = function()
                    vim.lsp.buf.inlay_hint(0, true)
                end,
            })
            vim.api.nvim_create_autocmd({ "InsertEnter" }, {
                group = vim.api.nvim_create_augroup("DisableInlayHint", { clear = true }),
                callback = function()
                    vim.lsp.buf.inlay_hint(0, false)
                end,
            })
        end
    end
    -- 高亮相同变量或者函数
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

return M
