return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
    config = function()
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        local handlers = require("nvim-autopairs.completion.handlers")

        cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done({
                filetypes = {
                    -- "*" is a alias to all filetypes
                    ["*"] = {
                        ["("] = {
                            kind = {
                                cmp.lsp.CompletionItemKind.Function,
                                cmp.lsp.CompletionItemKind.Method,
                            },
                            handler = handlers["*"],
                        },
                    },
                    lua = {
                        ["("] = {
                            kind = {
                                cmp.lsp.CompletionItemKind.Function,
                                cmp.lsp.CompletionItemKind.Method,
                            },
                            ---@param char string
                            ---@param item table item completion
                            ---@param bufnr number buffer number
                            ---@param rules table
                            ---@param commit_character table<string>
                            handler = function(char, item, bufnr, rules, commit_character)
                                -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
                            end,
                        },
                    },
                    tex = false,
                    rust = false,
                    go = false,
                    zig = false,
                },
            })
        )
    end,
}
