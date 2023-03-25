return {
    "ziontee113/icon-picker.nvim",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader><leader>i", mode = { "n" } },
        { "<leader><leader>y", mode = { "n" } },
        { "<C-i>", mode = { "i" } },
    },
    config = function()
        local opts = { noremap = true, silent = true }

        vim.keymap.set("n", "<Leader><Leader>i", ":IconPickerNormal<cr>", opts)
        vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
        vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)

        require("icon-picker").setup({
            disable_legacy_commands = true,
        })
    end,
}
