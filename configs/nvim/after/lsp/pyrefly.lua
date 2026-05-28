---@type vim.lsp.Config
return {
    single_file_support = true,
    settings = {
        python = {
            analysis = {
                inlayHints = {
                    callArgumentNames = "all",
                    pytestParameters = true,
                },
            },
        },
    },
}
