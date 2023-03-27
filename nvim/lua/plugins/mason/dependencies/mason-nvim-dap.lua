return {
    "jayp0521/mason-nvim-dap.nvim",
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = {
                "bash",
                "delve",
                -- "javadbg",
                "python",
                "codelldb",
            },
            -- Can either be:
            --   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
            --       Example: automatic_installation = { exclude = { "python", "delve" } }
            automatic_installation = true,
            -- Whether adapters that are installed in mason should be automatically set up in dap.
            -- Removes the need to set up dap manually.
            -- See mappings.adapters and mappings.configurations for settings.
            -- Must invoke when set to true: `require 'mason-nvim-dap'.setup_handlers()`
            -- Can either be:
            -- 	- false: Dap is not automatically configured.
            -- 	- true: Dap is automatically configured.
            -- 	- {adapters: {ADAPTER: {}, }, configurations: {ADAPTER: {}, }}. Allows overriding default configuration.
            automatic_setup = false,
        })
        -- require 'mason-nvim-dap'.setup_handlers()
    end,
}
