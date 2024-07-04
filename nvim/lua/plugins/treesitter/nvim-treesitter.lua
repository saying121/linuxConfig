local ts  = vim.treesitter

---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    -- version = "*",
    build = ":TSUpdate",
    dependencies = require("public.utils").req_lua_files_return_table("plugins/" .. "treesitter" .. "/dependencies"),
    config = function()
        local my_ft = require("public.ft")

        local ft = my_ft.filename["Cargo.toml"]
        if type(ft) == "string" then
            ts.language.register("toml", ft)
        end
        ts.language.register("bash", "PKGBUILD")
        ts.language.register("bash", "zsh")

        -- 如果没有可用高亮就用默认的
        if require("nvim-treesitter.parsers").available_parsers()[vim.bo.filetype] == nil then
            vim.cmd("syntax on")
        end
        if vim.env.HTTPS_PROXY == nil then
            require("nvim-treesitter.install").prefer_git = true
            local mirror = require("public.utils").mirror()

            for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
                config.install_info.url =
                    config.install_info.url:gsub("https://github.com/", mirror .. "https://github.com/")
            end
        end

        require("nvim-treesitter.configs").setup({
            ensure_installed = "all",
            ignore_install = {
                "c",
                "lua",
                "bash",
                "query",
                "vimdoc",
                "python",
                "markdown",
                "markdown_inline",
                "comment",
            },
            sync_install = false,
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gsn",
                    -- node_incremental = "<C-i>",
                    node_incremental = "<CR>",
                    -- node_decremental = "grm",
                    node_decremental = "<BS>",
                    scope_incremental = "<Tab>",
                    -- scope_incremental = "grc",
                },
            },
            indent = { enable = false },
            highlight = {
                enable = true,
                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser)
                -- list of language that will be disabled
                -- disable = { 'conf' },

                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    local fts = {
                        ["csv"] = true,
                        ["dockerfile"] = true,
                    }

                    if fts[lang] then
                        return true
                    end

                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end

                    local tb = {
                        -- rust = "rust-analyzer",
                        zig = "zls",
                    }
                    for k, value in pairs(tb) do
                        if lang == k and #vim.lsp.get_clients({ name = value, bufnr = buf }) > 0 then
                            -- if lang == k then
                            return true
                        end
                    end
                end,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}
