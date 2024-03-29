local function h(name)
    return vim.api.nvim_get_hl(0, { name = name })
end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

---@param symbol Symbol
---@return table
local function text_format(symbol)
    local res = {}

    local round_start = { "", "SymbolUsageRounding" }
    local round_end = { "", "SymbolUsageRounding" }

    if symbol.references then
        local usage = symbol.references <= 1 and "usage" or "usages"
        local num = symbol.references == 0 and "no" or symbol.references
        table.insert(res, round_start)
        table.insert(res, { "󰌹 ", "SymbolUsageRef" })
        table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
        table.insert(res, round_end)
    end

    if symbol.definition then
        if #res > 0 then
            table.insert(res, { " ", "NonText" })
        end
        table.insert(res, round_start)
        table.insert(res, { "󰳽 ", "SymbolUsageDef" })
        table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
        table.insert(res, round_end)
    end

    if symbol.implementation and symbol.implementation > 0 then
        if #res > 0 then
            table.insert(res, { " ", "NonText" })
        end
        table.insert(res, round_start)
        table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
        table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
        table.insert(res, round_end)
    end

    return res
end

---@type LazySpec
return {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
        local SymbolKind, langs = vim.lsp.protocol.SymbolKind, require("symbol-usage.langs")

        require("symbol-usage").setup({
            ---@type table<string, any> `nvim_set_hl`-like options for highlight virtual text
            hl = { link = "LspCodeLens" },
            ---@type lsp.SymbolKind[] Symbol kinds what need to be count (see `lsp.SymbolKind`)
            kinds = { SymbolKind.Function, SymbolKind.Method },
            ---Additional filter for kinds. Recommended use in the filetypes override table.
            ---fiterKind: function(data: { symbol:table, parent:table, bufnr:integer }): boolean
            ---`symbol` and `parent` is an item from `textDocument/documentSymbol` request
            ---See: #filter-kinds
            ---@type table<lsp.SymbolKind, filterKind[]>
            kinds_filter = {},
            vt_position = "end_of_line",
            ---Text to display when request is pending. If `false`, extmark will not be
            ---created until the request is finished. Recommended to use with `above`
            ---vt_position to avoid "jumping lines".
            ---@type string|table|false
            request_pending_text = "loading...",
            ---The function can return a string to which the highlighting group from `opts.hl` is applied.
            ---Alternatively, it can return a table of tuples of the form `{ { text, hl_group }, ... }`` - in this case the specified groups will be applied.
            ---See `#format-text-examples`
            ---@type function(symbol: Symbol): string|table Symbol{ definition = integer|nil, implementation = integer|nil, references = integer|nil }
            text_format = text_format,

            references = { enabled = true, include_declaration = true },
            definition = { enabled = true },
            implementation = { enabled = true },
            disable = { lsp = { "rust-analyzer" }, filetypes = {} },
            filetypes = {
                lua = langs.lua,
                javascript = langs.javascript,
                typescript = langs.javascript,
                typescriptreact = langs.javascript,
                javascriptreact = langs.javascript,
                vue = langs.javascript,
            },

            ---@type 'start'|'end' At which position of `symbol.selectionRange` the request to the lsp server should start. Default is `end` (try changing it to `start` if the symbol counting is not correct).
            symbol_request_pos = "end", -- Recommended redifine only in `filetypes` override table
        })
    end,
}
