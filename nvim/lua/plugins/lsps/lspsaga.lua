return {
    "glepnir/lspsaga.nvim",
    -- Do make sure that your LSP plugins, like lsp-zero or lsp-config, are loaded before loading lspsaga.
    event = "LspAttach",
    keys = {
        { "<space>gg" },
        { "[d" },
        { "]d" },
        { "[e" },
        { "]e" },
    },
    -- commit = "",
    config = function()
        local keymap = vim.keymap.set

        local callhierarchy = {
            layout = "float",
            keys = {
                edit = "e",
                vsplit = "v",
                split = "s",
                tabe = "t",
                quit = "q",
                shuttle = "[", -- shuttle between the layout left and right
                toggle_or_req = "u", -- toggle or do request.
                close = "<C-c>k", -- close layout
            },
        }
        keymap("n", "<Leader>ci", function()
            vim.cmd.Lspsaga("incoming_calls")
        end)
        keymap("n", "<Leader>co", function()
            vim.cmd.Lspsaga("outgoing_calls")
        end)

        local code_action = {
            num_shortcut = true,
            show_server_name = true,
            extend_gitsigns = false,
            keys = {
                -- string | table type
                quit = "q",
                exec = "<CR>",
            },
        }
        keymap({ "n", "x" }, "<M-CR>", function()
            vim.cmd.Lspsaga("code_action")
        end)

        local definition = {
            edit = "<C-c>o",
            vsplit = "<C-c>v",
            split = "<C-c>i",
            tabe = "<C-c>t",
            quit = "q",
            close = "<C-c>k",
        }
        keymap("n", "gd", function()
            vim.cmd.Lspsaga("goto_definition")
        end)
        keymap("n", "gD", function()
            vim.cmd.Lspsaga("peek_definition")
        end)
        keymap("n", "gy", function()
            vim.cmd.Lspsaga("goto_type_definition")
        end)
        keymap("n", "gY", function()
            vim.cmd.Lspsaga("peek_type_definition")
        end)

        vim.diagnostic.config({
            virtual_text = false,
        })
        local diagnostic = {
            show_code_action = true,
            jump_num_shortcut = true,
            max_width = 0.7,
            max_height = 0.6,
            text_hl_follow = true,
            border_follow = true,
            extend_relatedInformation = false,
            show_layout = "float",
            show_normal_height = 10,
            max_show_width = 0.9,
            max_show_height = 0.6,
            diagnostic_only_current = true,
            keys = {
                exec_action = "o",
                quit = "q",
                expand_or_jump = "<CR>",
                quit_in_show = { "q", "<ESC>" },
            },
        }
        -- Show line diagnostics
        -- You can pass argument ++unfocus to
        -- unfocus the show_line_diagnostics floating window
        keymap("n", "<space>gg", function()
            vim.cmd.Lspsaga("show_line_diagnostics")
        end)

        -- keymap("n", "<space>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
        -- Show buffer diagnostics
        -- keymap("n", "<space>ll", "<cmd>Lspsaga show_buf_diagnostics<CR>")
        -- Diagnostic jump
        keymap("n", "[d", function()
            vim.cmd.Lspsaga("diagnostic_jump_prev")
        end)
        keymap("n", "]d", function()
            vim.cmd.Lspsaga("diagnostic_jump_next")
        end)
        -- Diagnostic jump with filters such as only jumping to an error
        keymap("n", "[e", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end)
        keymap("n", "]e", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)

        local finder = {
            max_height = 0.45,
            left_width = 0.3,
            default = "def+ref",
            layout = "float",
            keys = {
                shuttle = "[",
                toggle_or_open = "o", -- toggle expand or open
                vsplit = "s", -- open in vsplit
                split = "i", -- open in split
                tabe = "t", -- open in tabe
                tabnew = "r", -- open in new tab
                quit = "q", -- quit the finder, only works in layout left window
                close = "<C-c>", -- close finder
            },
        }
        -- you can use <C-t> to jump back
        keymap("n", "gh", function()
            vim.cmd.Lspsaga("finder")
        end)
        keymap("n", "gi", function()
            vim.cmd.Lspsaga({ "finder", "imp" })
        end)
        keymap("n", "gH", function()
            vim.cmd.Lspsaga({ "finder", "def+ref+imp" })
        end)
        keymap("n", "gF", function()
            vim.cmd.Lspsaga({ "finder", "def" })
        end)

        local hover = {
            max_width = 0.8,
            max_height = 0.4,
            open_link = "gx",
            -- open_cmd = "!chrome",
        }
        -- If you want to jump to the hover window you should use the wincmd command "<C-w>w"
        keymap("n", "ck", function()
            vim.cmd.Lspsaga({ "hover_doc", "++keep" })
        end)

        local outline = {
            win_position = "right", -- window position
            win_width = 30, -- window width
            auto_preview = true, -- auto preview when cursor moved in outline window
            detail = true, -- show detail
            auto_close = true, -- auto close itself when outline window is last window
            close_after_jump = false, -- close after jump
            keys = {
                toggle_or_jump = "o",
                quit = "q",
                jump = "e",
            },
        }
        keymap("n", "<leader>ol", function()
            vim.cmd.Lspsaga({ "outline" })
        end)

        local rename = {
            in_select = false,
            auto_save = false,
            project_max_width = 0.5,
            project_max_height = 0.5,
            keys = {
                quit = "`",
                exec = "<CR>",
                select = "x",
            },
        }
        -- Rename all occurrences of the hovered word for the entire file
        keymap("n", "<space>rn", function()
            vim.cmd.Lspsaga("rename")
        end)
        -- Rename all occurrences of the hovered word for the selected files
        keymap("n", "<space>Rn", function()
            vim.cmd.Lspsaga({ "rename", "++project" })
        end)

        require("lspsaga").setup({
            symbol_in_winbar = {
                enable = false,
                hide_keyword = true,
                show_file = true,
                folder_level = 2,
            },
            callhierarchy = callhierarchy,
            code_action = code_action,
            definition = definition,
            diagnostic = diagnostic,
            finder = finder,
            hover = hover,
            implement = {
                enable = true,
                sign = false,
                virtual_text = true,
                priority = 30,
            },
            lightbulb = {
                enable = true,
                sign = false,
                virtual_text = true,
                debounce = 10,
                sign_priority = 40,
            },
            outline = outline,
            rename = rename,
            ui = {
                collapse = "",
                expand = "",
                title = true,
                devicon = true,
            },
        })

        keymap({ "n", "t" }, "<M-a>", function()
            vim.cmd.Lspsaga("term_toggle")
        end)
    end,
}
