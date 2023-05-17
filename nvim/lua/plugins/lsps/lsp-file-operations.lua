local ft = {
    rust = "rs",
    typescript = "ts",
    scala = "scala",
}

local events = {}

for _, value in pairs(ft) do
    table.insert(events, "UIEnter *." .. value)
    table.insert(events, "BufNew *." .. value)
end

return {
    "antosha417/nvim-lsp-file-operations",
    event = events,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        require("lsp-file-operations").setup({
            debug = true,
        })
    end,
}
