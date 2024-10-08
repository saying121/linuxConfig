---@type LazySpec
return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
        -- Where Mason should put its bin location in your PATH. Can be one of:
        -- - "prepend" (default, Mason's bin location is put first in PATH)
        -- - "append" (Mason's bin location is put at the end of PATH)
        -- - "skip" (doesn't modify PATH)
        ---@type '"prepend"' | '"append"' | '"skip"'
        PATH = "append",
        github = {
            -- download_url_template = "https://ay1.us/https://github.com/%s/releases/download/%s/%s",
            download_url_template = require("public.utils").mirror() .. "https://github.com/%s/releases/download/%s/%s",
        },
        pip = {
            -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
            upgrade_pip = true,
            -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
            install_args = {},
        },
        -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
        -- debugging issues with package installations.
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 8,
        -- The provider implementations to use for resolving package metadata (latest version, available versions, etc.).
        -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
        -- Builtin providers are:
        --   - mason.providers.registry-api (default) - uses the https://api.mason-registry.dev API
        --   - mason.providers.client                 - uses only client-side tooling to resolve metadata
        -- providers = {
        --     "mason.providers.registry-api",
        -- },
        ui = {
            icons = {
                package_pending = " ",
                package_installed = "󰄳 ",
                package_uninstalled = "󰚌 ",
            },
            check_outdated_packages_on_open = true,
            -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
            border = "double",
            width = 0.8,
            height = 0.8,
            keymaps = {
                -- Keymap to expand a package
                toggle_package_expand = "<CR>",
                -- Keymap to install the package under the current cursor position
                install_package = "i",
                -- Keymap to reinstall/update the package under the current cursor position
                update_package = "s",
                -- Keymap to check for new version for the package under the current cursor position
                check_package_version = "c",
                -- Keymap to update all installed packages
                update_all_packages = "S",
                -- Keymap to check which installed packages are outdated
                check_outdated_packages = "C",
                -- Keymap to uninstall a package
                uninstall_package = "x",
                -- Keymap to cancel a package installation
                cancel_installation = "<C-c>",
                -- Keymap to apply language filter
                apply_language_filter = "<C-f>",
            },
        },
    },
}
