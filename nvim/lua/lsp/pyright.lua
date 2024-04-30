local lsp = vim.lsp
local LSP = require("public.lsp_attach")
return {
    single_file_support = true,
    settings = {},
    ---@param client lsp.Client
    ---@param bufnr integer
    on_attach = function(client,bufnr)
        LSP.on_attach(client, bufnr)

        local orig_rpc_request = client.rpc.request
        function client.rpc.request(method, params, handler, ...)
            local orig_handler = handler
            if method == "textDocument/completion" then
                -- Idiotic take on <https://github.com/fannheyward/coc-pyright/blob/6a091180a076ec80b23d5fc46e4bc27d4e6b59fb/src/index.ts#L90-L107>.
                ---@type fun(err: lsp.ResponseError|nil, result: any)
                handler = function(err, result)
                    if not err and result then
                        local items = result.items or result
                        for _, item in ipairs(items) do
                            if
                                not (item.data and item.data.funcParensDisabled)
                                and (
                                    item.kind == lsp.protocol.CompletionItemKind.Function
                                    or item.kind == lsp.protocol.CompletionItemKind.Method
                                    or item.kind == lsp.protocol.CompletionItemKind.Constructor
                                )
                            then
                                item.insertText = item.label .. "($1)$0"
                                item.insertTextFormat = lsp.protocol.InsertTextFormat.Snippet
                            end
                        end
                    end
                    return orig_handler(err, result)
                end
            end
            return orig_rpc_request(method, params, handler, ...)
        end
    end,
}
