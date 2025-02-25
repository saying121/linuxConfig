---@type LazySpec
return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "typescript" },
    cond = false,
    config = function()
        local api = require("typescript-tools.api")
        require("typescript-tools").setup({
            on_attach = require("public.lsp_attach").on_attach,
            handlers = {
                ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
                    -- Ignore 'This may be converted to an async function' diagnostics.
                    { 80006 }
                ),
            },
            settings = {
                -- spawn additional tsserver instance to calculate diagnostics on it
                separate_diagnostic_server = true,
                -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                publish_diagnostic_on = "insert_leave",
                -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                -- "remove_unused_imports"|"organize_imports") -- or string "all"
                -- to include all supported code actions
                -- specify commands exposed as code_actions
                expose_as_code_action = {},
                -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                -- not exists then standard path resolution strategy is applied
                tsserver_path = nil,
                -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                -- (see 💅 `styled-components` support section)
                tsserver_plugins = {
                    -- for TypeScript v4.9+
                    "@styled/typescript-styled-plugin",
                    -- or for older TypeScript versions
                    -- "typescript-styled-plugin",
                },
                -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                -- memory limit in megabytes or "auto"(basically no limit)
                tsserver_max_memory = "auto",
                -- locale of all tsserver messages, supported locales you can find here:
                -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                tsserver_locale = "en",
                -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                complete_function_calls = false,
                include_completions_with_insert_text = true,
                -- CodeLens
                -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                code_lens = "off",
                -- by default code lenses are displayed on all referencable values and for some of you it can
                -- be too much this option reduce count of them by removing member references from lenses
                disable_member_code_lens = true,
                javascript = {
                    implementationsCodeLens = { enabled = true },
                    referencesCodeLens = {
                        enabled = true,
                        showOnAllFunctions = true,
                    },
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
                typescript = {
                    implementationsCodeLens = { enabled = true },
                    referencesCodeLens = {
                        enabled = true,
                        showOnAllFunctions = true,
                    },
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
                tsserver_format_options = {
                    autoImportFileExcludePatterns = {},
                    quotePreference = "auto",
                    includeCompletionsForImportStatements = true,
                    includeCompletionsWithSnippetText = true,
                    includeCompletionsWithInsertText = true,
                    includeAutomaticOptionalChainCompletions = true,
                    includeCompletionsWithObjectLiteralMethodSnippets = true,
                    useLabelDetailsInCompletionEntries = true,
                    allowIncompleteCompletions = true,
                    importModuleSpecifierPreference = "shortest",
                    importModuleSpecifierEnding = "auto",
                    allowTextChangesInNewFiles = true,
                    lazyConfiguredProjectsFromExternalProject = false,
                    organizeImportsCollation = "ordinal",
                    organizeImportsCollationLocale = "en", -- auto
                    organizeImportsNumericCollation = false,
                    organizeImportsAccentCollation = true,
                    organizeImportsCaseFirst = false,
                    providePrefixAndSuffixTextForRename = true,
                    allowRenameOfImportPath = false,
                    includePackageJsonAutoImports = "auto",
                    interactiveInlayHints = true,
                    jsxAttributeCompletionStyle = "auto",
                    displayPartsForJSDoc = true,
                    excludeLibrarySymbolsInNavTo = true,
                    generateReturnInDocTemplate = true,
                },
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
        })
    end,
}
