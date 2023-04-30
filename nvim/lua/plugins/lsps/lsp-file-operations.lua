return {
    "antosha417/nvim-lsp-file-operations",
    event = {
        'BufNew *.rs,*.ts,*.scala',
        'UIEnter *.rs,*.ts,*.scala',
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- "nvim-tree/nvim-tree.lua", 会导致 nvim-tree 配置失效
        -- require("plugins.navigation.nvim-tree"),
    },
    config = function()
        require("lsp-file-operations").setup({
            debug = true,
        })
    end,
}
