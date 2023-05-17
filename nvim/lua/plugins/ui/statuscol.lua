return {
    "luukvbaal/statuscol.nvim",
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
            -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
            -- Although I recommend just using the segments field below to build your
            -- statuscolumn to benefit from the performance optimizations in this plugin.
            -- builtin.lnumfunc number string options
            thousands = false, -- or line number thousands separator string ("." / ",")
            relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
            -- Builtin 'statuscolumn' options
            ft_ignore = nil, -- lua table with filetypes for which 'statuscolumn' will be unset
            bt_ignore = nil, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            -- Default segments (fold -> sign -> line number + separator), explained below
            segments = {
                { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                { text = { "%s" }, click = "v:lua.ScSa" },
                {
                    text = { " ", builtin.lnumfunc, " " },
                    condition = { true, builtin.not_empty },
                    click = "v:lua.ScLa",
                },
            },
            clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
            -- "a" for Alt, "c" for Ctrl and "m" for Meta.
        })
    end,
}
