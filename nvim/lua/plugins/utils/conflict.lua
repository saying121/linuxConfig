return {
    "akinsho/git-conflict.nvim",
    build = [[
git config --global merge.tool git-conflict
git config --global mergetool.git-conflict.cmd 'nvim -c GitConflictRefresh "$MERGED"'
git config --global mergetool.git-conflict.trustExitCode true
git config --global mergetool.keepBackup false
    ]],
    version = "*",
    cmd = { "GitConflictRefresh" },
    config = function()
        require("git-conflict").setup({
            default_mappings = false,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "GitConflictDetected",
            callback = function()
                vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
                local keymap = vim.keymap.set

                keymap("n", "co", "<Plug>(git-conflict-ours)")
                keymap("n", "ct", "<Plug>(git-conflict-theirs)")
                keymap("n", "cb", "<Plug>(git-conflict-both)")
                keymap("n", "c0", "<Plug>(git-conflict-none)")
                keymap("n", "[x", "<Plug>(git-conflict-prev-conflict)")
                keymap("n", "]x", "<Plug>(git-conflict-next-conflict)")
            end,
        })
    end,
}
