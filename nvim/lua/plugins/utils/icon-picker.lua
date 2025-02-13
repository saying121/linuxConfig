---@type LazySpec
return {
    "ziontee113/icon-picker.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    keys = {
        { "<leader><leader>i", mode = { "n" } },
        { "<leader><leader>y", mode = { "n" } },
        { "<C-S-i>", mode = { "i" } },
    },
    config = function()
        local opts = { noremap = true, silent = true }

        local keymap = vim.keymap.set
        keymap("n", "<Leader><Leader>i", ":IconPickerNormal<cr>", opts)
        keymap("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
        keymap("i", "<C-S-i>", "<cmd>IconPickerInsert<cr>", opts)

        require("icon-picker").setup({
            disable_legacy_commands = true,
        })
    end,
}
