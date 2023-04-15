return {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    keys = {
        { "<leader>e" },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- file icons
    },
    version = "nightly", -- optional, updated every week. (see issue #1193)
    config = function()
        vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        local M = {}

        local api = require("nvim-tree.api")

        function M.on_attach(bufnr)
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            -- put some default mappings here
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "o", api.tree.change_root_to_node, opts("CD"))
            vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
            vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
        end

        -- OR setup with some options
        require("nvim-tree").setup({
            on_attach = M.on_attach,
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
                mappings = {
                    list = {
                        { key = "u", action = "dir_up" },
                    },
                },
            },
            renderer = {
                group_empty = true,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                debounce_delay = 50,
            },
            filters = {
                dotfiles = true,
            },
            trash = {
                cmd = "trash-put",
                require_confirm = true,
            },
        })
    end,
}
