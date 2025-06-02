local vfn = vim.fn

---@type LazySpec
return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000000000,
    ---@type snacks.Config
    opts = {
        image = {
            enable = true,
            doc = {
                enable = true,
                inline = true,
            },
        },
        explorer = {},
        picker = {
            enable = true,
            ui_select = true,
            win = {
                input = {
                    keys = {
                        ["t"] = { "tab", mode = { "n" } },
                    },
                },
            },
            sources = {
                explorer = {
                    hidden = false,
                    layout = {
                        cycle = false,
                    },
                    win = {
                        input = {
                            ["<Esc>"] = { "", mode = { "n", "x" } },
                        },
                        list = {
                            keys = {
                                ["t"] = "tab",
                                ["<Esc>"] = { "", mode = { "n", "x" } },
                                ["u"] = "explorer_up",
                                ["a"] = "explorer_add",
                                ["d"] = "explorer_del",
                                ["r"] = "explorer_rename",
                                ["c"] = "explorer_copy",
                                ["m"] = "explorer_move",
                                ["o"] = "explorer_open", -- open with system application
                                ["y"] = { "explorer_yank", mode = { "n", "x" } },
                                ["p"] = "explorer_paste",
                                ["U"] = "explorer_update",
                                ["<c-c>"] = "tcd",
                                ["<leader>/"] = "picker_grep",
                                ["<c-t>"] = "terminal",
                                ["."] = "explorer_focus",
                                ["I"] = "toggle_ignored",
                                ["H"] = "toggle_hidden",
                                ["Z"] = "explorer_close_all",
                            },
                        },
                    },
                },
            },
        },
        scroll = { enabled = false },
        input = { enabled = true },
        scope = { enabled = true },
        chunk = { enabled = true },
        animate = { enabled = true },
        indent = {
            enabled = true,
            priority = 1,
            only_scope = false, -- only show indent guides of the scope
            only_current = false, -- only show indent guides in the current window
            filter = function(buf)
                -- local b = vim.b[buf]
                local bo = vim.bo[buf]
                local excluded_filetypes = {
                    text = true,
                    Trouble = true,
                    alpha = true,
                    dashboard = true,
                    help = true,
                    lazy = true,
                    lspsagafinder = true,
                    mason = true,
                    ["neo-tree"] = true,
                    NvimTree = true,
                    toggleterm = true,
                    markdown = true,
                }
                return bo.buftype == "" and not excluded_filetypes[bo.filetype]
            end,
        },
        bigfile = {
            enabled = true,
            size = 1.5 * 1024 * 1024, -- 1.5MB
        },
        gitbrowse = {},
        statuscolumn = {
            enabled = true,
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "git", "fold" }, -- priority of signs on the right (high to low)
            folds = {
                open = true, -- show open fold icons
                git_hl = false, -- use Git Signs hl for fold icons
            },
        },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        local keymap = vim.keymap.set
        local snacks = require("snacks")
        local picker = snacks.picker
        local util = require("public.utils")

        local function git_picker(fn)
            if util.is_git_repo() then
                fn({ cwd = util.get_root_dir(vfn.getcwd(), ".git") })
            else
                fn()
            end
        end

        keymap({ "n", "x" }, "<leader>go", snacks.gitbrowse.open)

        keymap("n", "<leader>ff", picker.files)
        keymap("n", "<leader>gf", function()
            git_picker(picker.files)
        end)
        keymap("n", "<leader>fw", picker.grep)
        keymap("n", "<leader>gw", function()
            git_picker(picker.grep)
        end)
        keymap("n", "<leader>bf", picker.buffers)
        keymap("n", "gI", function()
            picker.lsp_implementations({
                layout = {
                    preset = "vscode",
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    preview = true,
                    layout = {
                        width = 0.8,
                        height = 0.6,
                        border = "rounded",
                    },
                },
            })
        end)
        keymap("n", "gr", picker.lsp_references)

        keymap("n", "<leader>fo", picker.recent)

        keymap("n", "<leader>e", picker.explorer)

        local term = require("snacks.terminal")
        keymap({ "t", "n" }, "<M-t>", function()
            term.toggle(nil, { win = { border = "double", position = "float" } })
        end)

        -- keymap({ "t" }, "<M-t>", "<C-\\><C-n>:ToggleTerm<CR>", opts)
    end,
}
