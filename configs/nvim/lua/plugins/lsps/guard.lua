---@type LazySpec
return {
    "nvimdev/guard.nvim",
    dependencies = { "nvimdev/guard-collection" },
    cond=false,
    -- keys = "<space>f",
    config = function()
        local keymap = vim.keymap.set
        local api = vim.api
        api.nvim_create_autocmd({ "UIEnter", "BufEnter" }, {
            group = api.nvim_create_augroup("Fmt", { clear = true }),
            pattern = { "typst", "zsh" },
            callback = function()
                keymap({ "n", "x" }, "<space>f", vim.cmd.GuardFmt, { buffer = 0 })
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
