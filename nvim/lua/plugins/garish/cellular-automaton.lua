return {
    "eandrju/cellular-automaton.nvim",
    lazy = true,
    keys = {
        { "<leader>ra", mode = "n", desc = "rain" },
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<leader>ra", "<cmd>CellularAutomaton make_it_rain<CR>", opts)
        local config1 = {
            fps = 50,
            name = "snake",
        }

        -- init function is invoked only once at the start
        -- config.init = function (grid)
        --
        -- end

        -- update function
        config1.update = function(grid)
            for i = 1, #grid do
                local prev = grid[i][#grid[i]]
                for j = 1, #grid[i] do
                    grid[i][j], prev = prev, grid[i][j]
                end
            end
            return true
        end

        require("cellular-automaton").register_animation(config1)

        local config2 = {
            fps = 50,
            name = "snake",
        }
        config2.update = function(grid)
            for i = 1, #grid do
                local prev = grid[i][#grid[i]]
                for j = 1, #grid[i] do
                    grid[i][j], prev = prev, grid[i][j]
                end
            end
            return true
        end

        require("cellular-automaton").register_animation(config2)
    end,
}
