return {
    "LintaoAmons/scratch.nvim",
    keys = {
        { "<M-C-n>", mode = "n" },
    },
    version = "v0.2.0", --  tag for stability, or without this to have latest fixed and functions
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<M-C-n>", function()
            require("scratch").scratch()
        end, opts)
        require("scratch").setup({
            scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- Where the scratch files will be saved
            filetypes = { "json", "xml", "go", "lua", "js", "py", "sh", "rs" }, -- filetypes to select from
        })
    end,
}
