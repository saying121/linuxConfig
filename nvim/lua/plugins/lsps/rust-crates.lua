return {
    "saecki/crates.nvim",
    version = "v0.3.0",
    event = {
        "UIEnter Cargo.toml",
        "BufNewFile Cargo.toml",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = vim.api.nvim_create_augroup("CratesKeyMap", { clear = true }),
            pattern = { "Cargo.toml" },
            callback = function()
                local crates = require("crates")
                -- 注释掉的可以用 K 打开 document 后操作
                local opts, keymap = { noremap = true, silent = true, buffer = true }, vim.keymap.set

                keymap("n", "ct", crates.toggle, opts)
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
        local null_ls = require("null-ls")

        crates.setup({
            smart_insert = true,
            insert_closing_quote = false,
            avoid_prerelease = true,
            autoload = true,
            autoupdate = true,
            loading_indicator = true,
            date_format = "%Y-%m-%d",
            thousands_separator = "_",
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
                    hide = { "q", "<esc>" },
                    open_url = { "<cr>", "K" },
                    select = { "<cr>" },
                    select_alt = { "s" },
                    toggle_feature = { "<cr>" },
                    copy_value = { "y" },
                    goto_item = { "gd", "K", "<C-LeftMouse>" },
                    jump_forward = { "<c-i>" },
                    jump_back = { "<c-o>", "<C-RightMouse>" },
                },
            },
            src = {
                insert_closing_quote = true,
                text = {
                    prerelease = "  pre-release ",
                    yanked = "  yanked ",
                },
            },
            null_ls = {
                enabled = true,
                name = "Crates.nvim",
            },
        })

        -- 启动的时候刷新下信息
        crates.reload()
    end,
}
