local signs = {
    ERROR = { name = "DiagnosticSignError", text = " " }, --
    WARN = { name = "DiagnosticSignWarn", text = " " }, --
    HINT = { name = "DiagnosticSignHint", text = " " },--📌 
    INFO = { name = "DiagnosticSignInfo", text = " " }, --
}

for _, sign in pairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

---@diagnostic disable-next-line: unused-local
local virtual_text = {
    severity = false,
    spacing = 4, -- severity = {
    --     max = vim.diagnostic.severity.ERROR,
    --     min = vim.diagnostic.severity.WARN,
    -- },
    prefix = "", -- ●
    source = "if_many", --- boolean
    format = function(diagnostic)
        for MS, sign in pairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            if diagnostic.severity == vim.diagnostic.severity[MS] then
                return signs[MS].text .. ": " .. diagnostic.message
            end
        end
        return diagnostic.message
    end,
}

vim.diagnostic.config({
    -- virtual_text = false,
    virtual_text = virtual_text,
    float = { border = "single" },
    severity_sort = true, -- 根据严重程度排序
    signs = true,
    underline = false,
    update_in_insert = true,
})

-- 被注释的部分，被 lspsaga.nvim 和 trouble.nvim 取代了
local M = {}
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    keymap("n", "<leader>v", function()
        if vim.diagnostic.is_disabled() then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end, opts)

    -- keymap("n", "<space>e", vim.diagnostic.open_float)
    -- keymap("n", "[d", vim.diagnostic.goto_prev)
    -- keymap("n", "]d", vim.diagnostic.goto_next)
    -- keymap("n", "<space>q", vim.diagnostic.setloclist)
    -- keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    -- keymap('n', 'gd', vim.lsp.buf.definition, opts)
    -- keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    -- keymap('n', 'gr', vim.lsp.buf.references, opts)
    -- keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap("n", "<c-k>", vim.lsp.buf.signature_help, opts)

    -- keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    -- keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    -- keymap("n", "<space>wl", function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)

    -- keymap("n", "gy", vim.lsp.buf.type_definition, opts)
    -- keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- keymap('n', '<M-cr>', vim.lsp.buf.code_action, opts)

    -- print(vim.inspect(client))
    local cap = client.server_capabilities
    -- print(vim.inspect(cap))

    if cap.inlayHintProvider ~= nil then
        local _ = pcall(vim.lsp.inlay_hint.enable, bufnr, true)
    end

    if cap.documentFormattingProvider then
        keymap("n", "<space>f", function()
            vim.lsp.buf.format({
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
            vim.lsp.buf.format({ async = true })
        end, opts)
    end

    if cap.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = vim.api.nvim_create_augroup("LspHighlightHold", { clear = false }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            group = vim.api.nvim_create_augroup("LspHighlightMoved", { clear = false }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end

    if cap.codeLensProvider ~= nil and cap.codeLensProvider.resolveProvider then
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("CodeLensRefresh", { clear = false }),
            buffer = bufnr,
            callback = function()
                -- vim.lsp.codelens.refresh()
                local _ = pcall(vim.lsp.codelens.refresh)
            end,
        })
    end
end

return M
