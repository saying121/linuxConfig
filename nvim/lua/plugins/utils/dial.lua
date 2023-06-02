return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>", mode = { "n", "x" } },
        { "<C-x>", mode = { "n", "x" } },
    },
    config = function()
        vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal("mygroup"), { noremap = true })
        vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal("mygroup"), { noremap = true })
        vim.keymap.set("x", "<C-a>", require("dial.map").inc_visual("mygroup"), { noremap = true })
        vim.keymap.set("x", "<C-x>", require("dial.map").dec_visual("mygroup"), { noremap = true })
        vim.keymap.set("x", "g<C-a>", require("dial.map").inc_gvisual("mygroup"), { noremap = true })
        vim.keymap.set("x", "g<C-x>", require("dial.map").dec_gvisual("mygroup"), { noremap = true })

        local augend = require("dial.augend")
        local mygroup = {
            augend.integer.alias.decimal,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha,
            -- augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.integer.new({
                radix = 16,
                prefix = "0x",
                natural = true,
                case = "upper",
            }),
            augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
            augend.constant.new({
                elements = { "and", "or" },
                word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "True", "False" },
                word = true, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "+", "-" },
                word = true, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "+=", "-=" },
                word = true, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "<", ">" },
                word = true, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "&&", "||" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "++", "--" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "!==", "===" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "MAX", "MIN" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December",
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "first",
                    "second",
                    "third",
                    "fourth",
                    "fifth",
                    "sixth",
                    "seventh",
                    "eighth",
                    "ninth",
                    "tenth",
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "zero",
                    "one",
                    "two",
                    "three",
                    "four",
                    "five",
                    "six",
                    "seven",
                    "eight",
                    "nine",
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "max", "min" },
                word = true,
                cyclic = true,
            }),

            augend.hexcolor.new({
                case = "lower",
            }),
            augend.constant.new({
                elements = { "==", "!=" },
                word = true,
                cyclic = true,
            }),
        }

        -- if vim.bo.ft == "lua" then
        --     table.insert(
        --         mygroup,
        --         augend.constant.new({
        --             elements = { "==", "~=" },
        --             word = true,
        --             cyclic = true,
        --         })
        --     )
        -- else
        --     table.insert(
        --         mygroup,
        --         augend.constant.new({
        --             elements = { "==", "!=" },
        --             word = true,
        --             cyclic = true,
        --         })
        --     )
        -- end

        require("dial.config").augends:register_group({
            -- default augends used when no group name is specified
            default = {
                augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
            },
            -- augends used when group with name `mygroup` is specified
            mygroup = mygroup,
        })
    end,
}
