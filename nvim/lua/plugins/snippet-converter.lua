return {
    "smjonas/snippet-converter.nvim",
    cmd = "ConvertSnippets",
    config = function()
        local template = {
            -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
            sources = {
                ultisnips = {
                    -- Add snippets from (plugin) folders or individual files on your runtimepath...
                    "./vim-snippets/UltiSnips",
                    "./latex-snippets/tex.snippets",
                    -- ...or use absolute paths on your system.
                    vim.fn.stdpath("config") .. "/UltiSnips",
                },
                snipmate = {
                    "vim-snippets/snippets",
                },
            },
            output = {
                -- Specify the output formats and paths
                vscode_luasnip = {
                    vim.fn.stdpath("config") .. "/luasnip_snippets",
                },
            },
        }

        require("snippet_converter").setup({
            templates = { template },
            -- To change the default settings (see configuration section in the documentation)
            -- settings = {},
        })
    end,
}
