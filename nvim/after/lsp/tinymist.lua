---@type vim.lsp.Config
return {
    root_dir = function()
        vim.fn.getcwd()
    end,
    single_file_support = true,
    settings = {
        exportPdf = "onSave",
        typstExtraArgs = {},
        formatterMode = "typstyle",
    },
}
