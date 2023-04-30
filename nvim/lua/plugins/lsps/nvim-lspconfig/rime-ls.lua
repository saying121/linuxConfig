return {
    "wlh320/rime-ls",
    keys = { "<A-g>" },
    config = function()
        -- global status
        vim.g.rime_enabled = false
        -- add rime-ls to lspconfig as a custom server
        require("lspconfig.configs").rime_ls = {
            default_config = {
                name = "rime_ls",
                cmd = { "rime_ls" },
                filetypes = { "*" },
                single_file_support = true,
            },
            settings = {},
            docs = {
                description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
            },
        }

        local rime_on_attach = function(client, _)
            local toggle_rime = function()
                client.request(
                    "workspace/executeCommand",
                    { command = "rime-ls.toggle-rime" },
                    function(_, result, ctx, _)
                        if ctx.client_id == client.id then
                            vim.g.rime_enabled = result
                        end
                    end
                )
            end
            vim.keymap.set({ "n", "i" }, "<A-g>", function()
                toggle_rime()
            end)
            vim.keymap.set("n", "<leader>rs", function()
                vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
            end)
        end

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        require("lspconfig").rime_ls.setup({
            init_options = {
                enabled = vim.g.rime_enabled,
                shared_data_dir = "/usr/share/rime-data",
                user_data_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
                log_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
                max_candidates = 9,
                -- trigger_characters = { '::' },
            },
            on_attach = rime_on_attach,
            capabilities = capabilities,
        })

        -- rime-ls 不能懒加载
        -- 为了开启rime-ls,好像也能开启lsp
        -- if vim.bo.ft == "dashboard" then
        --     vim.cmd("e")
        -- else
        --     vim.cmd("w|e")
        -- end
    end,
}
