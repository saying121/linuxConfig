local keymap = vim.keymap.set
---@type LazySpec
return {
    "nvim-tree/nvim-tree.lua",
    -- cond = false,
    keys = { "<leader>e" },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    version = "*",
    config = function()
        local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
        vim.api.nvim_create_autocmd("User", {
            pattern = "NvimTreeSetup",
            callback = function()
                local events = require("nvim-tree.api").events
                events.subscribe(events.Event.NodeRenamed, function(data)
                    if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                        data = data
                        Snacks.rename.on_rename_file(data.old_name, data.new_name)
                    end
                end)
            end,
        })

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
            view = {
                width = 60,
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
