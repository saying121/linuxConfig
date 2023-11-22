return {
    "glepnir/lspsaga.nvim",
    -- Do make sure that your LSP plugins, like lsp-zero or lsp-config, are loaded before loading lspsaga.
    event = "LspAttach",
    -- commit = "4f075452c466df263e69ae142f6659dcf9324bf6",
    -- commit = "8a05cb18092d49075cf533aaf17d312e2ad61d77",
    dependencies = {
        -- Please make sure you install markdown and markdown_inline parser
        "nvim-treesitter/nvim-treesitter",
    },
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
                shuttle = "[w", -- shuttle bettween the layout left and right
                toggle_or_req = "u", -- toggle or do request.
                close = "<C-c>k", -- close layout
            },
        }
        keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
        keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

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
        keymap({ "n", "x" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>")

        local definition = {
            edit = "<C-c>o",
            vsplit = "<C-c>v",
            split = "<C-c>i",
            tabe = "<C-c>t",
            quit = "q",
            close = "<C-c>k",
        }
        keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
        keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>")
        keymap("n", "gy", "<cmd>Lspsaga goto_type_definition<CR>")
        keymap("n", "gY", "<cmd>Lspsaga peek_type_definition<CR>")

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
        if vim.bo.filetype == "markdown" then
            local theopts = { noremap = true, silent = true }
            keymap("n", "<space>gg", vim.diagnostic.open_float, theopts)
        else
            keymap("n", "<space>gg", "<cmd>Lspsaga show_line_diagnostics<CR>")
        end

        -- keymap("n", "<space>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
        -- Show buffer diagnostics
        -- keymap("n", "<space>ll", "<cmd>Lspsaga show_buf_diagnostics<CR>")
        -- Diagnostic jump
        keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
        -- Diagnostic jump with filters such as only jumping to an error
        keymap("n", "[e", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end)
        keymap("n", "]e", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)

        local finder = {
            max_height = 0.5,
            left_width = 0.3,
            default = "def+ref",
            layout = "float",
            keys = {
                shuttle = "[w",
                toggle_or_open = "o", -- toggle expand or open
                vsplit = "s", -- open in vsplit
                split = "i", -- open in split
                tabe = "t", -- open in tabe
                tabnew = "r", -- open in new tab
                quit = "q", -- quit the finder, only works in layout left window
                close = "<C-c>k", -- close finder
            },
        }
        -- you can use <C-t> to jump back
        keymap("n", "gh", "<cmd>Lspsaga finder<CR>")
        keymap("n", "gi", "<cmd>Lspsaga finder imp<CR>")
        keymap("n", "gH", "<cmd>Lspsaga finder def+ref+imp<CR>")
        keymap("n", "gF", "<cmd>Lspsaga finder def<CR>")

        local hover = {
            max_width = 0.8,
            max_height = 0.4,
            open_link = "gx",
            -- open_cmd = "!chrome",
        }
        -- If you want to jump to the hover window you should use the wincmd command "<C-w>w"
        keymap("n", "ck", "<cmd>Lspsaga hover_doc ++keep<CR>")

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
        keymap("n", "<leader>ol", "<cmd>Lspsaga outline<CR>")

        local rename = {
            in_select = false,
            auto_save = false,
            project_max_width = 0.5,
            project_max_height = 0.5,
            keys = {
                quit = "<C-c>",
                exec = "<CR>",
                select = "x",
            },
        }
        -- Rename all occurrences of the hovered word for the entire file
        keymap("n", "<space>rn", "<cmd>Lspsaga rename<CR>")
        -- Rename all occurrences of the hovered word for the selected files
        keymap("n", "<space>Rn", "<cmd>Lspsaga rename ++project<CR>")

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
                sign = true,
                virtual_text = false,
                debounce = 10,
                sign_priority = 40,
            },
            outline = outline,
            rename = rename,
        })

        keymap({ "n", "t" }, "<M-a>", "<cmd>Lspsaga term_toggle<CR>")
    end,
}
