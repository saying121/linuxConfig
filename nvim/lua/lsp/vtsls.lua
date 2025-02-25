---@type vim.lsp.ClientConfig
return {
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
    },
    settings = {
        complete_function_calls = true,
        vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            experimental = {
                maxInlayHintLength = 30,
                completion = {
                    enableServerSideFuzzyMatch = true,
                },
            },
            tsserver = {
                globalPlugins = {
                    {
                        configNamespace = "typescript",
                        enableForWorkspaceTypeScriptVersions = true,
                        languages = { "vue" },
                        location = "/usr/lib/node_modules/@vue/language-server",
                        name = "@vue/typescript-plugin",
                    },
                },
            },
        },
        typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            -- tsdk = "./node_modules/typescript/lib",
            suggest = {
                completeFunctionCalls = true,
            },
            inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
            },
        },
    },
}
