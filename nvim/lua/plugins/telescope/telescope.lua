return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", mode = "n" },
        { "<leader>gf", mode = "n" },
        { "<leader>fw", mode = "n" },
        { "<leader>gw", mode = "n" },
        { "<leader>fo", mode = "n" },
        { "<leader>bf", mode = "n" },
        { "ti", mode = "n" },
        { "<M-p>", mode = "n" },
    },
    version = "0.1.2",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        require("public.utils").req_lua_files_return_table("plugins/" .. "telescope" .. "/dependencies"),
    },
    config = function()
        local builtin, keymap = require("telescope.builtin"), vim.keymap.set
        local opts = { noremap = true, silent = true }
        local util = require("public.utils")

        keymap("n", "<leader>ff", builtin.find_files, opts)
        keymap("n", "<leader>fw", builtin.live_grep, opts)
        keymap("n", "<leader>fo", builtin.oldfiles, opts)
        keymap("n", "<leader>bf", builtin.buffers, opts)
        keymap("n", "ti", builtin.lsp_implementations, opts)

        local function find_files_from_git_root()
            local function is_git_repo()
                vim.fn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                opts = { cwd = util.get_git_root_dir(vim.fn.getcwd(), "/.git") }
            end
            builtin.find_files(opts)
        end
        keymap("n", "<leader>gf", find_files_from_git_root, opts)

        local function live_grep_from_git_root()
            local function is_git_repo()
                vim.fn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                opts = { cwd = util.get_git_root_dir(vim.fn.getcwd(), "/.git") }
            end
            builtin.live_grep(opts)
        end
        keymap("n", "<leader>gw", live_grep_from_git_root, opts)

        local telescope = require("telescope")
        telescope.load_extension("media_files")
        telescope.load_extension("noice")

        local actions = require("telescope.actions")

        local trouble = require("trouble.providers.telescope")

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
                        ["<c-t>"] = trouble.open_with_trouble,
                    },
                    n = {
                        ["<C-h>"] = "which_key",
                        ["t"] = "select_tab",
                        ["<c-t>"] = trouble.open_with_trouble,
                    },
                },
                layout_config = {
                    vertical = { width = 0.5 },
                    -- other layout configuration here
                },
            },
            pickers = {
                -- Default configuration for builtin pickers goes here:
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    prompt_prefix = "🔍",
                    mappings = {
                        n = {
                            ["t"] = actions.select_tab + actions.move_to_top,
                        },
                    },
                },
                -- live_grep = {
                --     find_command = {},
                -- },
                buffers = {
                    prompt_prefix = "﬘ ",
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                        },
                        n = {
                            -- ["dd"] = actions.delete_buffer + actions.move_to_top,
                            ["dd"] = "delete_buffer",
                        },
                    },
                },
                keymaps = {
                    prompt_prefix = "🎹",
                },
                live_grep = {
                    prompt_prefix = " ",
                },
                builtin = {
                    prompt_prefix = " ",
                },
                highlights = {
                    prompt_prefix = "⚡",
                },
                oldfiles = {
                    prompt_prefix = " ",
                },
            },
            extensions = {
                media_files = {
                    -- filetypes whitelist
                    -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    -- find command (defaults to `fd`)
                    find_cmd = "rg",
                },
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
