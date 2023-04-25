return {
    "saecki/crates.nvim",
    cond = function()
        return vim.bo.ft == "rust" or vim.fn.expand("%:t") == "Cargo.toml" or false
    end,
    version = "v0.3.0",
    -- event = "BufWinEnter Cargo.toml",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- 有一个 keymap 在 lspsaga 里面
        "glepnir/lspsaga.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        local crates = require("crates")

        vim.api.nvim_create_autocmd({ "BufWinEnter Cargo.toml", "BufEnter Cargo.toml" }, {
            group = vim.api.nvim_create_augroup("CreatesReload", { clear = true }),
            pattern = { "Cargo.toml" },
            callback = function()
                -- 注释掉的可以用 K 打开 document 后操作
                local opts, keymap = { noremap = true, silent = true, buffer = true }, vim.keymap.set

                keymap("n", "<leader>ct", crates.toggle, opts)
                keymap("n", "<leader>cr", crates.reload, opts)

                -- keymap("n", "<leader>cv", crates.show_versions_popup, opts)
                keymap("n", "<leader>cf", crates.show_features_popup, opts)
                keymap("n", "<leader>cd", crates.show_dependencies_popup, opts)

                keymap("n", "<leader>cu", crates.update_crate, opts)
                keymap("v", "<leader>cu", crates.update_crates, opts)
                -- keymap("n", "<leader>ca", crates.update_all_crates, opts)
                -- keymap("n", "<leader>cA", crates.upgrade_all_crates, opts)

                -- keymap("n", "<leader>cH", crates.open_homepage, opts)
                -- keymap("n", "<leader>cR", crates.open_repository, opts)
                -- keymap("n", "<leader>cD", crates.open_documentation, opts)
                -- keymap("n", "<leader>cC", crates.open_crates_io, opts)
            end,
        })

        crates.setup({
            smart_insert = true,
            insert_closing_quote = false,
            avoid_prerelease = true,
            autoload = true,
            autoupdate = true,
            loading_indicator = true,
            date_format = "%Y-%m-%d",
            thousands_separator = ",",
            notification_title = "Crates",
            disable_invalid_feature_diagnostic = false,
            popup = {
                autofocus = false,
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