local api = vim.api
---@type LazySpec
return {
    "lmburns/lf.nvim",
    dependencies = { "toggleterm.nvim" },
    keys = { "<leader>lf" },
    config = function()
        -- Defaults
        require("lf").setup({
            default_action = "drop", -- default action when `Lf` opens a file
            default_actions = { -- default action keybindings
                ["t"] = "tabedit",
                ["<C-x>"] = "split",
                ["<C-v>"] = "vsplit",
                ["<C-o>"] = "tab drop",
            },
            winblend = 16, -- psuedotransparency level
            dir = "", -- directory where `lf` starts ('gwd' is git-working-directory, ""/nil is CWD)
            direction = "float", -- window type: float horizontal vertical
            border = "double", -- border kind: single double shadow curved rounded
            -- height = vim.fn.float2nr(vim.fn.round(0.75 * vim.api.nvim_win_get_height(0))),  -- height of the *floating* window
            -- width = vim.fn.float2nr(vim.fn.round(0.75 * vim.api.nvim_win_get_width(0))), -- width of the *floating* window
            height = 40,
            width = 150,
            escape_quit = true, -- map escape to the quit command (so it doesn't go into a meta normal mode)
            focus_on_open = true, -- focus the current file when opening Lf (experimental)
            mappings = true, -- whether terminal buffer mapping is enabled
            tmux = false, -- tmux statusline can be disabled on opening of Lf
            highlights = { -- highlights passed to toggleterm
                Normal = { link = "Normal" },
                NormalFloat = { link = "Normal" },
                -- FloatBorder = { guifg = "<VALUE>", guibg = "<VALUE>" },
            },

            -- Layout configurations
            layout_mapping = "<M-u>", -- resize window with this key
            views = { -- window dimensions to rotate through
                { width = 0.800, height = 0.800 },
                { width = 0.600, height = 0.600 },
                { width = 0.950, height = 0.950 },
                { width = 0.500, height = 0.500, col = 0, row = 0 },
                { width = 0.500, height = 0.500, col = 0, row = 0.5 },
                { width = 0.500, height = 0.500, col = 0.5, row = 0 },
                { width = 0.500, height = 0.500, col = 0.5, row = 0.5 },
            },
        })

        vim.keymap.set("n", "<leader>lf", "<Cmd>Lf<CR>")

        api.nvim_create_autocmd({ "User" }, {
            pattern = "LfTermEnter",
            callback = function(a)
                api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
            end,
        })
    end,
}
