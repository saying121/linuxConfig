return {
    "nvimdev/guard.nvim",
    cond = false,
    dependencies = { "nvimdev/guard-collection" },
    -- keys = "<space>f",
    config = function()
        local keymap = vim.keymap.set
        vim.api.nvim_create_autocmd({ "UIEnter", "BufEnter" }, {
            group = vim.api.nvim_create_augroup("Fmt", { clear = true }),
            pattern = { "typst", "asm" },
            callback = function()
                keymap({ "n", "x" }, "<space>f", vim.cmd.GuardFmt, { bufnr = 0 })
            end,
        })

        local filetype = require("guard.filetype")

        -- call setup LAST
        require("guard").setup({
            -- the only option for the setup function
            fmt_on_save = false,
            lsp_as_default_formatter = true,
        })
    end,
}
