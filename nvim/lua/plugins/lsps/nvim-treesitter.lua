return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    ft = "dashboard",
    dependencies = {
        "HiPhish/nvim-ts-rainbow2",
        require("plugins.lsps.lspsaga"),
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "c",
                "java",
                "lua",
                "python",
                "vim",
                "markdown",
                "markdown_inline",
                "awk",
            },
            sync_install = true,
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "a",
                    scope_incremental = "<CR>",
                    node_decremental = "<BS>",
                },
            },
            indent = {
                enable = false,
            },
            highlight = {
                enable = true,
                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser)
                -- list of language that will be disabled
                -- disable = { 'conf' },

                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                ---@diagnostic disable-next-line: unused-local
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            rainbow = {
                enable = true,
                -- list of languages you want to disable the plugin for
                disable = { "jsx", "cpp" },
                -- Which query to use for finding delimiters
                query = "rainbow-parens",
                -- Highlight the entire buffer all at once
                strategy = require("ts-rainbow.strategy.global"),
                -- Do not enable for files with more than n lines
                max_file_lines = 3000,
            },
        })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            pattern = { "*" },
            group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", { clear = true }),
            callback = function()
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                vim.cmd([[normal zR]])
            end,
        })
    end,
}
