---@type LazySpec
return {
    "p00f/clangd_extensions.nvim",
    event = {
        "LspAttach *.c",
        "LspAttach *.cpp",
        "LspAttach *.cu",
    },
}
