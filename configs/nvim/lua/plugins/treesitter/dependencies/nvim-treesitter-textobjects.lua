---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "v", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = false,
            },
            move = {
                set_jumps = true,
            },
        })

        local select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")
        local tobj = select.select_textobject
        local goto_next = move.goto_next
        local goto_previous = move.goto_previous
        local goto_next_start = move.goto_next_start
        local goto_next_end = move.goto_next_end
        local goto_previous_start = move.goto_previous_start
        local goto_previous_end = move.goto_previous_end

        -- keymaps
        -- You can use the capture groups defined in `textobjects.scm`
        vim.keymap.set({ "x", "o" }, "af", function()
            tobj("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "if", function()
            tobj("@function.inner", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ac", function()
            tobj("@class.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ic", function()
            tobj("@class.inner", "textobjects")
        end)
        -- You can also use captures from other query groups like `locals.scm`
        vim.keymap.set({ "x", "o" }, "as", function()
            tobj("@local.scope", "locals")
        end)

        vim.keymap.set({ "x", "o" }, "al", function()
            tobj("@loop.outer", "locals")
        end)
        vim.keymap.set({ "x", "o" }, "il", function()
            tobj("@loop.inner", "locals")
        end)

        -- You can use the capture groups defined in `textobjects.scm`
        vim.keymap.set({ "n", "x", "o" }, "]f", function()
            goto_next_start("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "]c", function()
            goto_next_start("@class.outer", "textobjects")
        end)
        -- You can also pass a list to group multiple queries.
        vim.keymap.set({ "n", "x", "o" }, "]o", function()
            goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
        end)
        -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
        vim.keymap.set({ "n", "x", "o" }, "]s", function()
            goto_next_start("@local.scope", "locals")
        end)
        -- use nvim-ufo
        -- vim.keymap.set({ "n", "x", "o" }, "]z", function()
        --     gonext("@fold", "folds")
        -- end)

        vim.keymap.set({ "n", "x", "o" }, "]F", function()
            goto_next_end("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "]C", function()
            goto_next_end("@class.outer", "textobjects")
        end)

        vim.keymap.set({ "n", "x", "o" }, "[f", function()
            goto_previous_start("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "[c", function()
            goto_previous_start("@class.outer", "textobjects")
        end)

        vim.keymap.set({ "n", "x", "o" }, "[F", function()
            goto_previous_end("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "[C", function()
            goto_previous_end("@class.outer", "textobjects")
        end)

        -- Go to either the start or the end, whichever is closer.
        -- Use if you want more granular movements
        vim.keymap.set({ "n", "x", "o" }, "]d", function()
            goto_next("@conditional.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "[d", function()
            goto_previous("@conditional.outer", "textobjects")
        end)

        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        vim.keymap.set({ "n", "x", "o" }, "'", ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

        -- vim way: ; goes to the direction you were moving.
        -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}
