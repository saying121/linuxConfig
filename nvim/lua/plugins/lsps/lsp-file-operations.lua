return {
    "antosha417/nvim-lsp-file-operations",
    cond = function()
        local ft = { rust = true, typescript = true, scala = true }
        return ft[vim.bo.ft] or false
    end,
    event = "VeryLazy",
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
