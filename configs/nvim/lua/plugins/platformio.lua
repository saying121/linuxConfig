---@type LazySpec
return {
    "anurag3301/nvim-platformio.lua",
    dependencies = {
        { "akinsho/nvim-toggleterm.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    cmd = {
        "Pioinit",
        "Piorun",
        "Piocmd",
        "Piolib",
        "Piomon",
        "Piodebug",
        "Piodb",
    },
    opts = {
        lsp = "clangd",
    },
}
