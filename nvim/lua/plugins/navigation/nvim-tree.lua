local keymap = vim.keymap.set
---@type LazySpec
return {
    "nvim-tree/nvim-tree.lua",
    -- cond = false,
    keys = { "<leader>e" },
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- file icons
        {
            "antosha417/nvim-lsp-file-operations",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("lsp-file-operations").setup({
                    debug = false,
                    -- select which file operations to enable
                    operations = {
                        willRenameFiles = true,
                        didRenameFiles = true,
                        willCreateFiles = true,
                        didCreateFiles = true,
                        willDeleteFiles = true,
                        didDeleteFiles = true,
                    },
                    -- how long to wait (in milliseconds) for file rename information before cancelling
                    timeout_ms = 10000,
                })
            end,
        },
    },
    version = "*",
    config = function()
        keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
        -- disable netrw at the very start of your init.lua (strongly advised)
        -- vim.g.loaded_netrw = 1
        -- vim.g.loaded_netrwPlugin = 1
        local M = {}

        local api = require("nvim-tree.api")

        function M.on_attach(bufnr)
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            -- put some default mappings here
            api.config.mappings.default_on_attach(bufnr)

            keymap("n", "o", api.tree.change_root_to_node, opts("CD"))
            keymap("n", "t", api.node.open.tab, opts("Open: New Tab"))
            keymap("n", "u", api.tree.change_root_to_parent, opts("Up"))
        end

        require("nvim-tree").setup({
            on_attach = M.on_attach,
            sync_root_with_cwd = true,
            respect_buf_cwd = false,
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            update_focused_file = {
                enable = true,
                update_root = {
                    enable = true,
                },
            },
            sort_by = "case_sensitive",
            renderer = {
                root_folder_label = false,
                highlight_git = false,
                highlight_opened_files = "none",
                indent_markers = {
                    enable = true,
                },
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    glyphs = {
                        folder = {
                            default = "",
                            open = "",
                            symlink = "",
                            symlink_open = "",
                            arrow_open = "",
                            arrow_closed = "",
                        },
                    },
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                debounce_delay = 50,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
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
