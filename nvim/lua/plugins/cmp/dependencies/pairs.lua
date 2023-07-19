return {
    "altermo/npairs-integrate-upair",
    dependencies = {
        "altermo/ultimate-autopair.nvim", -- 在 bash,zsh 的 if 判断括号里面很有用
        "windwp/nvim-autopairs",
    },
    config = function()
        require("npairs-int-upair").setup({
            map = "n", -- which of them should be the insert mode autopair
            cmap = "u", -- which of them should be the cmd mode autopair (only 'u' supported)
            bs = "n", -- which of them should be the backspace
            cr = "n", -- which of them should be the newline
            space = "u", -- which of them should be the space (only 'u' supported)
            c_h = "n", -- which of them should be the <C-h> (only 'n' supported)
            c_w = "n", -- which of them should be the <C-w> (only 'n' supported)

            fastwarp = "<A-e>", -- ultimate-autopair's fastwarp mapping ('' for disable)
            rfastwarp = "<A-E>", -- ultimate-autopair's reverse fastwarp mapping ('' for disable)
            fastwrap = "<A-]>", -- nvim-autopairs's fastwrap mapping ('' for disable)
            npairs_conf = {
                disable_filetype = { "TelescopePrompt" },
                disable_in_macro = false, -- disable when recording or executing a macro,
                disable_in_visualblock = false, -- disable when insert after visual block mode,
                disable_in_replace_mode = true,
                ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
                enable_moveright = true,
                enable_afterquote = true, -- add bracket pairs after quote
                enable_check_bracket_line = true, --- check bracket in same line
                enable_bracket_in_quote = true, --
                enable_abbr = false, -- trigger abbreviation
                break_undo = true, -- switch for basic rule break undo sequence
                check_ts = false,
                map_cr = true,
                map_bs = true, -- map the <BS> key
                map_c_h = false, -- Map the <C-h> key to delete a pair
                map_c_w = false, -- map <c-w> to delete a pair if possible
            }, -- nvim-autopairs's configuration
            upair_conf = {
                config_type = "default",
                map = true,
                --whether to allow any insert map
                cmap = true, --cmap stands for cmd-line map
                --whether to allow any cmd-line map
                pair_map = true,
                --whether to allow pair insert map
                pair_cmap = true,
                --whether to allow pair cmd-line map
                bs = {
                    -- *ultimate-autopair-map-backspace-config*
                    enable = true,
                    map = "<bs>", --string or table
                    cmap = "<bs>",
                    overjumps = true,
                    --(|foo) > bs > |foo
                    space = true,
                    --( |foo ) > bs > (|foo)
                },
                cr = {
                    -- *ultimate-autopair-map-newline-config*
                    enable = true,
                    map = "<cr>", --string or table
                    autoclose = false,
                    --(| > cr > (\n|\n)
                    --addsemi={}, --list of filetypes
                },
                space = {
                    -- *ultimate-autopair-map-space-config*
                    enable = true,
                    map = " ",
                    cmap = " ",
                    check_box_ft = { "markdown", "vimwiki" },
                    --+ [|] > space > + [ ]
                },
                fastwarp = {
                    -- *ultimate-autopair-map-fastwarp-config*
                    enable = true,
                    enable_normal = true,
                    enable_reverse = true,
                    hopout = false,
                    --{(|)} > fastwarp > {(}|)
                    map = "<A-e>",
                    rmap = "<A-E>",
                    cmap = "<A-e>",
                    rcmap = "<A-E>",
                    multiline = true,
                    --(|) > fastwarp > (\n|)
                    nocursormove = true,
                    --makes the cursor not move (|)foo > fastwarp > (|foo)
                    --disables multiline feature
                    do_nothing_if_fail = true,
                    --add a module so that if fastwarp fails
                    --then an `e` will not be inserted
                },
                extensions = {
                    -- *ultimate-autopair-extensions-default-config*
                    cmdtype = { types = { "/", "?", "@" }, p = 90 },
                    filetype = { p = 80, nft = { "TelescopePrompt" } },
                    escape = { filter = true, p = 70 },
                    string = { p = 60 },
                    --treenode={inside={'comment'},p=50},
                    rules = { p = 40 },
                    alpha = { p = 30 },
                    suround = { p = 20 },
                    fly = { other_char = { " " }, nofilter = false, p = 10 },
                },
                internal_pairs = { -- *ultimate-autopair-pairs-default-config*
                    {
                        "[",
                        "]",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        "(",
                        ")",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        "{",
                        "}",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        '"',
                        '"',
                        suround = true,
                        rules = {
                            { "when", { "filetype", "vim" }, { "not", { "regex", "^%s*$" } } },
                        },
                        string = true,
                    },
                    {
                        "'",
                        "'",
                        suround = true,
                        rules = {
                            { "when", { "option", "lisp" }, { "instring" } },
                        },
                        alpha = true,
                        nft = {
                            "tex",
                        },
                        string = true,
                    },
                    { "`", "`", nft = { "tex" } },
                    { "``", "''", ft = { "tex" } },
                    { "```", "```", newline = true, ft = { "markdown" } },
                    { "<!--", "-->", ft = { "markdown", "html" } },
                    { '"""', '"""', newline = true, ft = { "python" } },
                    { "'''", "'''", newline = true, ft = { "python" } },
                    { "string", type = "tsnode", string = true },
                    { "raw_string", type = "tsnode", string = true },
                },
            }, -- ultimate-autopair's configuration
        })
    end,
}
