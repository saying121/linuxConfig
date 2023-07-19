local ft = {
    rust = "rs",
    typescript = "ts",
    scala = "scala",
}

return {
    "antosha417/nvim-lsp-file-operations",
    event = require("public.utils").boot_event(ft),
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        require("lsp-file-operations").setup({
            debug = false,
        })
    end,
}
