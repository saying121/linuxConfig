---@type vim.lsp.Config
return {
    filetypes = { "bash", "sh", "zsh" },
    settings = {
        bashIde = {
            shellcheckPath = "shellcheck",
            -- shellcheckPath = "",
        },
    },
}
