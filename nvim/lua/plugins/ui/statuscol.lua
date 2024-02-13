return {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
            -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
            -- Although I recommend just using the segments field below to build your
            -- statuscolumn to benefit from the performance optimizations in this plugin.
            -- builtin.lnumfunc number string options
            thousands = ",", -- or line number thousands separator string ("." / ",")
            relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
            -- Builtin 'statuscolumn' options
            ft_ignore = nil, -- lua table with filetypes for which 'statuscolumn' will be unset
            bt_ignore = nil, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            segments = {
                { text = { builtin.foldfunc }, click = "v:lua.ScFa" }, -- fold
                {
                    -- text = { "%s" },
                    sign = {
                        namespace = { ".*" },
                        -- namespace = { "diagnostic*" },
                        -- name = { "Diagnostic" },
                        maxwidth = 2,
                        colwidth = 2,
                    },
                    click = "v:lua.ScLa",
                },
                {
                    sign = {
                        name = { "GitSign" },
                        namespace = { "gitsigns*" },
                        maxwidth = 2,
                        colwidth = 1,
                    },
                },
                {
                    text = { builtin.lnumfunc, " " },
                    condition = { true, builtin.not_empty },
                    click = "v:lua.ScLa",
                },
                {
                    sign = {
                        namespace = { "dap*" },
                        name = { "Dap" },
                        auto = true,
                        maxwidth = 1,
                        colwidth = 2,
                    },
                    click = "v:lua.ScSa",
                },
                -- { text = { "│" }, condition = { builtin.not_empty } },
            },
            clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
            -- "a" for Alt, "c" for Ctrl and "m" for Meta.
        })
    end,
}
