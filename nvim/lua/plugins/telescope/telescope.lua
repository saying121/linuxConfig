return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", mode = "n" },
        { "<leader>fw", mode = "n" },
        { "<leader>go", mode = "n" },
        { "<M-p>", mode = "n" },
    },
    ft = { "dashboard" },
    version = "0.1.0",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        require("public.merge").get_dependencies_table("telescope"),
    },
    config = function()
        local builtin, keymap = require("telescope.builtin"), vim.keymap.set
        local opts = { noremap = true, silent = true }
        local telescope = require("telescope")

        keymap("n", "<leader>ff", builtin.find_files, opts)
        keymap("n", "<leader>fw", builtin.live_grep, opts)
        keymap("n", "<leader>go", builtin.oldfiles, opts)
        -- keymap("n", "<M-p>", telescope.extensions.projects.projects, opts)

        require("telescope").load_extension("noice")

        telescope.setup({
            defaults = {
                -- Default configuration for telescope goes here:
                -- config_key = value,
                mappings = {
                    i = {
                        -- map actions.which_key to <C-h> (default: <C-/>)
                        -- actions.which_key shows the mappings for your picker,
                        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                        ["<C-h>"] = "which_key",
                    },
                },
                layout_config = {
                    vertical = { width = 0.5 },
                    -- other layout configuration here
                },
            },
            pickers = {
                -- Default configuration for builtin pickers goes here:
                -- picker_name = {
                --   picker_config_key = value,
                --   ...
                -- }
                -- Now the picker_config_key will be applied every time you call this
                -- builtin picker
            },
            extensions = {
                -- Your extension configuration goes here:
                -- project = {
                --     base_dirs = {
                --         "~/dev/src",
                --         { "~/dev/src2" },
                --         { "~/dev/src3", max_depth = 4 },
                --         { path = "~/dev/src4" },
                --         { path = "~/dev/src5", max_depth = 2 },
                --     },
                --     hidden_files = true, -- default: false
                --     theme = "dropdown",
                --     order_by = "asc",
                --     search_by = "title",
                --     sync_with_nvim_tree = true, -- default false
                -- },
                -- please take a look at the readme of the extension you want to configure
            },
        })
    end,
}