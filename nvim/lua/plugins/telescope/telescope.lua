local vfn = vim.fn

---@type LazySpec
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
        { "gr", mode = "n" },
    },
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        require("public.utils").req_lua_files_return_table("plugins/" .. "telescope" .. "/dependencies"),
    },
    config = function()
        local builtin, keymap = require("telescope.builtin"), vim.keymap.set
        local opts = { noremap = true, silent = true }
        local util = require("public.utils")
        local function layout()
            return require("telescope.themes").get_dropdown({
                layout_config = {
                    preview_cutoff = 1, -- Preview should always show (unless previewer = false)
                    width = function(_, max_columns, _)
                        return math.ceil(max_columns * 0.8)
                    end,
                    height = function(_, _, max_lines)
                        return math.min(max_lines, 15)
                    end,
                },
            })
        end

        keymap("n", "<leader>ff", builtin.find_files, opts)
        keymap("n", "<leader>fw", builtin.live_grep, opts)
        keymap("n", "<leader>fo", builtin.oldfiles, opts)
        keymap("n", "<leader>bf", builtin.buffers, opts)
        keymap("n", "ti", function()
            builtin.lsp_implementations(layout())
        end, opts)
        keymap("n", "gr", function()
            builtin.lsp_references(layout())
        end, opts)

        local function find_files_from_git_root()
            local function is_git_repo()
                vfn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                opts = { cwd = util.get_root_dir(vfn.getcwd(), "/.git") }
            end
            builtin.find_files(opts)
        end
        keymap("n", "<leader>gf", find_files_from_git_root, opts)

        local function live_grep_from_git_root()
            local function is_git_repo()
                vfn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                opts = { cwd = util.get_root_dir(vfn.getcwd(), "/.git") }
            end
            builtin.live_grep(opts)
        end
        keymap("n", "<leader>gw", live_grep_from_git_root, opts)

        local telescope = require("telescope")
        telescope.load_extension("noice")

        local actions = require("telescope.actions")

        local trouble = require("trouble.sources.telescope")

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
                        ["<c-t>"] = trouble.open,
                    },
                    n = {
                        ["<C-h>"] = "which_key",
                        ["t"] = "select_tab",
                        ["<c-t>"] = trouble.open,
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
                lsp_implementations = {
                    layout_config = {
                        vertical = { width = 0.9 },
                        preview_width = 0.5,
                        -- other layout configuration here
                    },
                    theme = "dropdown",
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
            },
        })
    end,
}
