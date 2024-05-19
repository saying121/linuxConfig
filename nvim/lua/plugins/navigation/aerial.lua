local api = vim.api
---@type LazySpec
return {
    "stevearc/aerial.nvim",
    keys = {
        { "<space>z", mode = "n", desc = "" },
    },
    config = function()
        local opts = { noremap = true, silent = true }
        api.nvim_set_keymap("n", "<space>z", "<cmd>AerialToggle!<CR>", opts)

        require("aerial").setup({
            layout = {
                -- These control the width of the aerial window.
                -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a list of mixed types.
                -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
                max_width = { 40, 0.2 },
                width = nil,
                min_width = 10,

                -- key-value pairs of window-local options for aerial window (e.g. winhl)
                win_opts = {},

                -- Determines the default direction to open the aerial window. The 'prefer'
                -- options will open the window in the other direction *if* there is a
                -- different buffer in the way of the preferred direction
                -- Enum: prefer_right, prefer_left, right, left, float
                default_direction = "prefer_left",

                -- Determines where the aerial window will be opened
                --   edge   - open aerial at the far right/left of the editor
                --   window - open aerial to the right/left of the current window
                placement = "window",

                -- When the symbols change, resize the aerial window (within min/max constraints) to fit
                resize_to_content = true,

                -- Preserve window size equality with (:help CTRL-W_=)
                preserve_equality = false,
            },
            -- optionally use on_attach to set keymaps when aerial has attached to a buffer
            -- on_attach = function(bufnr)
            --     -- Jump forwards/backwards with '{' and '}'
            --     vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
            --     vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
            -- end
            -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts.
            -- Additionally, if it is a string that matches "aerial.<name>",
            -- it will use the function at require("aerial.action").<name>
            -- Set to `false` to remove a keymap
            keymaps = {
                ["?"] = "actions.show_help",
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.jump",
                ["<2-LeftMouse>"] = "actions.jump",
                ["<C-v>"] = "actions.jump_vsplit",
                ["<C-s>"] = "actions.jump_split",
                ["p"] = "actions.scroll",
                ["<C-j>"] = "actions.down_and_scroll",
                ["<C-k>"] = "actions.up_and_scroll",
                ["{"] = "actions.prev",
                ["}"] = "actions.next",
                ["[["] = "actions.prev_up",
                ["]]"] = "actions.next_up",
                ["q"] = "actions.close",
                ["o"] = "actions.tree_toggle",
                ["za"] = "actions.tree_toggle",
                ["O"] = "actions.tree_toggle_recursive",
                ["zA"] = "actions.tree_toggle_recursive",
                ["l"] = "actions.tree_open",
                ["zo"] = "actions.tree_open",
                ["L"] = "actions.tree_open_recursive",
                ["zO"] = "actions.tree_open_recursive",
                ["h"] = "actions.tree_close",
                ["zc"] = "actions.tree_close",
                ["H"] = "actions.tree_close_recursive",
                ["zC"] = "actions.tree_close_recursive",
                ["zr"] = "actions.tree_increase_fold_level",
                ["zR"] = "actions.tree_open_all",
                ["zm"] = "actions.tree_decrease_fold_level",
                ["zM"] = "actions.tree_close_all",
                ["zx"] = "actions.tree_sync_folds",
                ["zX"] = "actions.tree_sync_folds",
            },
            -- A list of all symbols to display. Set to false to display all symbols.
            -- This can be a filetype map (see :help aerial-filetype-map)
            -- To see all available values, see :help SymbolKind
            filter_kind = {
                "Class",
                "Constructor",
                "Enum",
                "Function",
                "Interface",
                "Module",
                "Method",
                "Struct",
            },
            -- Determines line highlighting mode when multiple splits are visible.
            -- split_width   Each open window will have its cursor location marked in the
            --               aerial buffer. Each line will only be partially highlighted
            --               to indicate which window is at that location.
            -- full_width    Each open window will have its cursor location marked as a
            --               full-width highlight in the aerial buffer.
            -- last          Only the most-recently focused window will have its location
            --               marked in the aerial buffer.
            -- none          Do not show the cursor locations in the aerial window.
            highlight_mode = "split_width",
            -- Highlight the closest symbol if the cursor is not exactly on one.
            highlight_closest = true,
            -- Highlight the symbol in the source buffer when cursor is in the aerial win
            highlight_on_hover = false,
            -- When jumping to a symbol, highlight the line for this many ms.
            -- Set to false to disable
            highlight_on_jump = 300,
        })
    end,
}
