return {
    "ThePrimeagen/refactoring.nvim",
    keys = {
        { "<leader>rr", mode = { "n", "x" } },
        { "<leader>rp", mode = { "n" } },
        { "<leader>rv", mode = { "n", "x" } },
        { "<leader>rc", mode = { "n" } },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        -- "stevearc/dressing.nvim",
    },
    config = function()
        local keymap = vim.keymap.set

        -- prompt for a refactor to apply when the remap is triggered
        keymap({ "n", "x" }, "<leader>rr", function()
            require("refactoring").select_refactor()
        end)
        -- Note that not all refactor support both normal and visual mode

        -- You can also use below = true here to to change the position of the printf
        -- statement (or set two remaps for either one). This remap must be made in normal mode.
        keymap("n", "<leader>rp", function()
            require("refactoring").debug.printf({ below = false })
        end)

        -- Print var
        keymap({ "x", "n" }, "<leader>rv", function()
            require("refactoring").debug.print_var()
        end)
        -- Supports both visual and normal mode

        keymap("n", "<leader>rc", function()
            require("refactoring").debug.cleanup({})
        end)
        -- Supports only normal mode

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
