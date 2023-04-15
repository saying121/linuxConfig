return {
    "saecki/crates.nvim",
    cond = function()
        if vim.fn.expand("%:t") == "Cargo.toml" then
            return true
        end
        return false
    end,
    version = "v0.3.0",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- 有一个 keymap 在 lspsaga 里面
        "glepnir/lspsaga.nvim",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup.filetype("toml", {
            sources = cmp.config.sources({
                { name = "crates", priority = 1000 },
                { name = "luasnip", priority = 900 },
                { name = "nvim_lsp", priority = 800 },
                { name = "path", priority = 700 },
            }, {
                { name = "buffer", priority = 600 },
                { name = "rg", priority = 550 },
            }, {
                { name = "spell", priority = 500 },
                { name = "rime", priority = 500 },
            }),
        })
        -- 注释掉的可以用 K 打开 document 后操作
        local crates = require("crates")
        local opts, keymap = { silent = true, buffer = true }, vim.keymap.set

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
                -- hide_on_select = false,
                copy_register = '"',
                style = "minimal",
                border = "single",
                show_version_date = true,
                show_dependency_version = true,
                max_height = 30,
                min_width = 20,
                padding = 1,
                keys = {
                    hide = { "q", "<esc>" },
                    open_url = { "<cr>" },
                    select = { "<cr>" },
                    select_alt = { "s" },
                    toggle_feature = { "<cr>" },
                    copy_value = { "yy" },
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
                coq = {
                    enabled = false,
                    name = "Crates",
                },
            },
            null_ls = {
                enabled = true,
                name = "Crates.nvim",
            },
        })

        crates.reload()
    end,
}
