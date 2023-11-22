return {
    "mrcjkb/rustaceanvim",
    cond = false,
    version = "^3", -- Recommended
    ft = "rust",
    config = function()
        local extension_path = "/usr/lib/codelldb/"

        if not require("public.utils").file_exists(extension_path) then
            extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
        end

        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    require("public.lsp_attach").on_attach(client, bufnr)
                    local keymap, opts = vim.keymap.set, { noremap = true, silent = true, buffer = bufnr }

                    keymap("n", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "actions" })
                        vim.cmd.RustLsp({ "hover", "actions" })
                    end, opts)
                    keymap("x", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "range" })
                    end, opts)
                    keymap("n", "<M-e>", function()
                        vim.cmd.RustLsp("explainError")
                    end, opts)
                    keymap("n", "mk", function()
                        vim.cmd.RustLsp({ "moveItem", "up" })
                    end, opts)
                    keymap("n", "mj", function()
                        vim.cmd.RustLsp({ "moveItem", "down" })
                    end, opts)
                    keymap("n", "<leader>R", function()
                        vim.cmd.RustLsp({
                            "runnables" --[[ , 'last' ]] --[[ optional ]],
                        })
                    end, opts)
                    keymap("n", "<leader>D", function()
                        vim.cmd.RustLsp({
                            "debuggables" --[[ , 'last' ]] --[[ optional ]],
                        })
                    end, opts)
                    keymap("n", "<C-g>", function()
                        vim.cmd.RustLsp("openCargo")
                    end, opts)
                    keymap("n", "<S-CR>", function()
                        vim.cmd.RustLsp("expandMacro")
                    end, opts)
                    keymap("n", "<M-S-CR>", function()
                        vim.cmd.RustLsp("rebuildProcMacros")
                    end, opts)
                end,
                settings = require("plugins.lsps.rust.settings"),
            },
            -- DAP configuration
            dap = {
                adapter = require("rustaceanvim.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        }
    end,
}
