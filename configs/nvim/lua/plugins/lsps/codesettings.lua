return {
    "mrjones2014/codesettings.nvim",
    -- these are the default settings just set `opts = {}` to use defaults
    opts = {
        ---Look for these config files
        config_file_paths = { ".vscode/settings.json", "codesettings.json", "lspsettings.json" },
        ---Set filetype to jsonc when opening a file specified by `config_file_paths`,
        ---make sure you have the json tree-sitter parser installed for highlighting
        jsonc_filetype = true,
        ---Integrate with jsonls to provide LSP completion for LSP settings based on schemas
        jsonls_integration = true,
        ---Enable live reloading of settings when config files change; for servers that support it,
        ---this is done via the `workspace/didChangeConfiguration` notification, otherwise the
        ---server is restarted
        live_reload = false,
        ---List of loader extensions to use when loading settings; `string` values will be `require`d
        loader_extensions = { "codesettings.extensions.vscode" },
        ---Set up library paths for `lua_ls` automatically to pick up the generated type
        ---annotations provided by codesettings.nvim; to enable for only your nvim config,
        ---you can also do something like:
        ---lua_ls_integration = function()
        ---  return vim.uv.cwd() == ('%s/.config/nvim'):format(vim.env.HOME)
        ---end,
        ---This integration also works for emmylua_ls
        lua_ls_integration = true,
        ---How to merge lists; 'append' (default), 'prepend' or 'replace'
        merge_lists = "append",
        ---Provide your own root dir; can be a string or function returning a string.
        ---It should be/return the full absolute path to the root directory.
        ---If not set, defaults to `require('codesettings.util').get_root()`
        root_dir = nil,
    },
    -- I recommend loading on these filetype so that the
    -- jsonls integration, lua_ls integration, and jsonc filetype setup works
    ft = { "json", "jsonc", "lua" },
}
