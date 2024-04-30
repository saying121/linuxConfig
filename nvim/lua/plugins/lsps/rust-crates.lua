---@type LazySpec
return {
    "saecki/crates.nvim",
    -- tag = "stable",
    event = {
        "UIEnter Cargo.toml",
        "BufNewFile Cargo.toml",
    },
    init = function()
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = vim.api.nvim_create_augroup("CratesKeyMap", { clear = true }),
            pattern = { "Cargo.toml" },
            callback = function()
                local crates = require("crates")
                -- 注释掉的可以用 K 打开 document 后操作
                local opts, keymap = { noremap = true, silent = true, buffer = true }, vim.keymap.set

                -- keymap("n", "ct", crates.toggle, opts)
                keymap("n", "cr", crates.reload, opts)

                -- keymap("n", "<leader>cv", crates.show_versions_popup, opts)
                keymap("n", "cf", crates.show_features_popup, opts)
                keymap("n", "cd", crates.show_dependencies_popup, opts)

                keymap("n", "cu", crates.update_crate, opts)
                keymap("x", "cu", crates.update_crates, opts)
            end,
        })
    end,
    config = function()
        local crates = require("crates")

        vim.api.nvim_create_autocmd("BufRead", {
            group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
            pattern = "Cargo.toml",
            callback = function()
                require("cmp").setup.buffer({ sources = { { name = "crates" } } })
            end,
        })

        crates.setup({
            lsp = {
                enabled = true,
                on_attach = function(client, bufnr)
                    require("public.lsp_attach").on_attach(client, bufnr)
                end,
                actions = true,
                completion = true,
                hover = true,
            },
            src = {
                cmp = { enabled = false },
                insert_closing_quote = true,
                text = {
                    prerelease = "  pre-release ",
                    yanked = "  yanked ",
                },
            },
            smart_insert = true,
            insert_closing_quote = false,
            autoload = true,
            autoupdate = true,
            loading_indicator = true,
            date_format = "%Y-%m-%d",
            thousands_separator = "_",
            max_parallel_requests = 80,
            notification_title = "Crates",
            disable_invalid_feature_diagnostic = false,
            popup = {
                autofocus = true,
                copy_register = "+",
                style = "minimal", -- :h nvim_open_win()
                border = "single",
                show_version_date = true,
                show_dependency_version = true,
                max_height = 30,
                min_width = 20,
                padding = 1,
                keys = {
                    hide = { "q" },
                    open_url = { "<cr>", "K" },
                    select = { "<cr>" },
                    select_alt = { "s" },
                    toggle_feature = { "<cr>" },
                    copy_value = { "y" },
                    goto_item = { "gd", "K", "<C-LeftMouse>" },
                    jump_forward = { "<c-i>" },
                    jump_back = { "<esc>", "<c-o>", "<C-RightMouse>" },
                },
            },
        })
    end,
}
