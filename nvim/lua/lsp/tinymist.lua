return {
    -- root_dir = require("lspconfig").util.root_pattern(".git"),
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
