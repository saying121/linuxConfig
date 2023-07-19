return {
    "ThePrimeagen/refactoring.nvim",
    -- lazy = true,
    cond = true,
    keys = {
        { "<leader>rr", mode = { "n", "x" } },
        { "<leader>rp", mode = { "n" } },
        { "<leader>rv", mode = { "n", "x" } },
        { "<leader>rc", mode = { "n" } },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "stevearc/dressing.nvim",
    },
    config = function()
        local opts = { noremap = true, silent = true, expr = false }
        local keymap = vim.keymap.set

        -- prompt for a refactor to apply when the remap is triggered
        keymap("x", "<leader>rr", function()
            require("refactoring").select_refactor()
        end, opts)

        -- Extract block doesn't need visual mode
        -- Extract function and
        -- Extract variable need visual mode
        -- Inline variable can also pick up the identifier currently under the cursor without visual mode

        -- load refactoring Telescope extension
        require("telescope").load_extension("refactoring")
        -- remap to open the Telescope refactoring menu in visual mode
        keymap(
            "x",
            "<leader>rr",
            "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
            { noremap = true }
        )

        -- You can also use below = true here to to change the position of the printf
        -- statement (or set two remaps for either one). This remap must be made in normal mode.
        keymap("n", "<leader>rp", function()
            require("refactoring").debug.printf({ below = false })
        end, { noremap = true })

        ------ Print var

        -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
        keymap("n", "<leader>rv", function()
            require("refactoring").debug.print_var({ normal = true })
        end, { noremap = true })
        -- Remap in visual mode will print whatever is in the visual selection
        keymap("x", "<leader>rv", function()
            require("refactoring").debug.print_var({})
        end, { noremap = true })

        -- Cleanup function: this remap should be made in normal mode
        keymap("n", "<leader>rc", function()
            require("refactoring").debug.cleanup({})
        end, { noremap = true })

        require("refactoring").setup({
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            -- overriding printf statement for cpp
            printf_statements = {
                -- add a custom printf statement for cpp
                cpp = {
                    'std::cout << "%s" << std::endl;',
                },
            },
            -- overriding printf statement for cpp
            print_var_statements = {
                -- add a custom print var statement for cpp
                cpp = {
                    'printf("a custom statement %%s %s", %s)',
                },
            },
            -- overriding extract statement for go
            extract_var_statements = {
                go = "%s := %s // poggers",
            },
        })
    end,
}
