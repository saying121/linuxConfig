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
                -- lang = { "markdown", "norg", "image_nvim", "typst", "html", "css" },
                inline = true,
            },
        },
        picker = {
            enable = true,
            ui_select = true,
        },
        scroll = { enabled = true },
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
        -- TODO: can't remove foldlevel number
        ---@type snacks.statuscolumn.Config
        statuscolumn = {
            enabled = false,
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "fold", "git" }, -- priority of signs on the right (high to low)
            folds = {
                open = false, -- show open fold icons
                git_hl = false, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50, -- refresh at most every 50ms
        },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        local keymap = vim.keymap.set
        local snacks = require("snacks")
        local picker = snacks.picker
        local util = require("public.utils")

        keymap({ "n", "x" }, "<leader>go", snacks.gitbrowse.open)

        keymap("n", "<leader>ff", picker.files)
        keymap("n", "<leader>gf", function()
            local function is_git_repo()
                vfn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                picker.files({ cwd = util.get_root_dir(vfn.getcwd(), "/.git") })
            else
                picker.files()
            end
        end)
        keymap("n", "<leader>fw", picker.grep)
        keymap("n", "<leader>gw", function()
            local function is_git_repo()
                vfn.system("git rev-parse --is-inside-work-tree")

                return vim.v.shell_error == 0
            end
            if is_git_repo() then
                picker.grep({ cwd = util.get_root_dir(vfn.getcwd(), "/.git") })
            else
                picker.grep()
            end
        end)
        keymap("n", "<leader>bf", picker.buffers)
        keymap("n", "gI", function()
            picker.lsp_implementations({
                layout = {
                    preset = "vscode",
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
    end,
}
