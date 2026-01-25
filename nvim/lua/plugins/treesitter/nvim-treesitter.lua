---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    -- version = "*",
    dependencies = require("public.utils").req_lua_files_return_table("plugins/" .. "treesitter" .. "/dependencies"),
    config = function()
        -- -- 如果没有可用高亮就用默认的
        if require("nvim-treesitter.parsers")[vim.bo.filetype] == nil then
            vim.cmd("syntax on")
        end

        local parser_dir = vim.fn.stdpath("data") .. "/ts_parser"

        require("nvim-treesitter").setup({
            install_dir = parser_dir,
            -- ignore_install = {
            --     "hoon",
            --     "c",
            --     "lua",
            --     "query",
            --     "vimdoc",
            --     -- "python",
            --     "markdown",
            --     "markdown_inline",
            --     "comment",
            -- },
            -- highlight = {
            --     enable = true,
            --     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            --     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            --     -- the name of the parser)
            --     -- list of language that will be disabled
            --     -- disable = { 'conf' },
            --
            --     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            --     disable = function(lang, buf)
            --         local fts = {
            --             ["rust"] = true,
            --             ["csv"] = true,
            --             ["dockerfile"] = true,
            --         }
            --
            --         if fts[lang] then
            --             return true
            --         end
            --
            --         local max_filesize = 100 * 1024 -- 100 KB
            --         local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            --         if ok and stats and stats.size > max_filesize then
            --             return true
            --         end
            --
            --         local tb = {
            --             rust = "rust-analyzer",
            --             zig = "zls",
            --         }
            --         return tb[lang] and #vim.lsp.get_clients({ name = tb[lang], bufnr = buf }) > 0
            --     end,
            --     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            --     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            --     -- Using this option may slow down your editor, and you may see some duplicate highlights.
            --     -- Instead of true it can also be a list of languages
            --     additional_vim_regex_highlighting = false,
            -- },
        })
        -- require("nvim-treesitter").install(require("nvim-treesitter").get_available())
    end,
}
