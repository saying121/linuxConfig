return {
    "SmiteshP/nvim-navbuddy",
    -- event = "LspAttach",
    cmd = "Navbuddy",
    keys = "<leader>lg",
    dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>lg", require("nvim-navbuddy").open, opts)

        local navbuddy = require("nvim-navbuddy")
        local actions = require("nvim-navbuddy.actions")
        navbuddy.setup({
            window = {
                border = "single", -- "rounded", "double", "solid", "none"
                -- or an array with eight chars building up the border in a clockwise fashion
                -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
                size = "85%", -- Or table format example: { height = "40%", width = "100%"}
                position = "50%", -- Or table format example: { row = "100%", col = "0%"}
                scrolloff = 5, -- scrolloff value within navbuddy window
                sections = {
                    left = {
                        size = "10%",
                        border = nil, -- You can set border style for each section individually as well.
                    },
                    mid = {
                        size = "30%",
                        border = nil,
                    },
                    right = {
                        -- No size option for right most section. It fills to
                        -- remaining area.
                        border = nil,
                        preview = "leaf", -- Right section can show previews too.
                        -- Options: "leaf", "always" or "never"
                    },
                },
            },
            lsp = {
                auto_attach = true, -- If set to true, you don't need to manually use attach function
                preference = nil, -- list of lsp server names in order of preference
            },

            mappings = {
                ["0"] = actions.root(), -- Move to first panel

                ["s"] = actions.toggle_preview(), -- Show preview of current node

                ["t"] = actions.telescope({ -- Fuzzy finder at current level.
                    layout_config = { -- All options that can be
                        height = 0.60, -- passed to telescope.nvim's
                        width = 0.60, -- default can be passed here.
                        prompt_position = "top",
                        preview_width = 0.50,
                    },
                    -- layout_strategy = "horizontal",
                }),

                ["g?"] = actions.help(), -- Open mappings help window
            },
        })
    end,
}
