-- 被注释的部分，被 lspsaga.nvim 和 trouble.nvim 取代了
local M = {}
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
    -- lsp 图标，边框等等
    local signs = {
        ERROR = { name = "DiagnosticSignError", text = " " }, --
        WARN = { name = "DiagnosticSignWarn", text = " " }, --
        HINT = { name = "DiagnosticSignHint", text = " " },
        INFO = { name = "DiagnosticSignInfo", text = " " },
    }
    for _, sign in pairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    ---@diagnostic disable-next-line: unused-local
    local virtual_text = {
        severity = false,
        -- severity = {
        --     max = vim.diagnostic.severity.ERROR,
        --     min = vim.diagnostic.severity.WARN,
        -- },
        prefix = "", -- 前缀
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
        -- virtual_text = virtual_text,
        float = { border = "single" },
        severity_sort = true, -- 根据严重程度排序
        signs = true,
        underline = true,
        update_in_insert = true,
    })

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set
    local diagnostic_v = true
    keymap("n", "<leader>v", function()
        if diagnostic_v then
            diagnostic_v = false
            vim.diagnostic.disable()
        else
            diagnostic_v = true
            vim.diagnostic.enable()
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
    keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    keymap("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    -- keymap("n", "gy", vim.lsp.buf.type_definition, opts)
    -- keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- keymap('n', '<M-cr>', vim.lsp.buf.code_action, opts)

    -- print(vim.inspect(client))
    local cap = client.server_capabilities
    -- 取消下面的注释使用 :messages 可以查看 lsp 支持的功能
    -- print(vim.inspect(cap))

    -- inlay hints相关
    if cap.inlayHintProvider.resolveProvider then
        if vim.fn.has("nvim-0.10.0") == 1 then
            vim.lsp.inlay_hint(0, true)
        end
    end

    if cap.documentFormattingProvider then
        keymap("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end
    if cap.documentRangeFormattingProvider then
        keymap("x", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
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
