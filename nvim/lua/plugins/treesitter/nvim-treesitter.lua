return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
        require("public.utils").get_dependencies_table("treesitter"),
    },
    config = function()
        -- 如果没有可用高亮就用默认的
        if require("nvim-treesitter.parsers").available_parsers()[vim.bo.filetype] == nil then
            vim.cmd("syntax on")
        end

        require("nvim-treesitter.configs").setup({
            -- ensure_installed = installed_list,
            ensure_installed = "all",
            sync_install = false,
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "A",
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
                    --
                    -- local line_count = vim.api.nvim_buf_line_count(0)
                    -- if line_count > 2000 then
                    --     return true
                    -- end
                    --
                    -- local max_column = 0
                    -- for i = 1, line_count do
                    --     local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
                    --     local columns = vim.api.nvim_strwidth(line)
                    --     if columns > max_column then
                    --         max_column = columns
                    --     end
                    -- end
                    -- if max_column > 1500 then
                    --     return true
                    -- end
                end,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        })

        -- 移到 init 会有非预期行为
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
