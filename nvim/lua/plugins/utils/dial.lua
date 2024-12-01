local keymap = vim.keymap.set
---@type LazySpec
return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>", mode = { "n", "x" } },
        { "<C-x>", mode = { "n", "x" } },
    },
    config = function()
        local dial_map = require("dial.map")
        local augend = require("dial.augend")

        keymap("n", "<C-a>", dial_map.inc_normal("mygroup"), { noremap = true })
        keymap("n", "<C-x>", dial_map.dec_normal("mygroup"), { noremap = true })
        keymap("x", "<C-a>", dial_map.inc_visual("mygroup"), { noremap = true })
        keymap("x", "<C-x>", dial_map.dec_visual("mygroup"), { noremap = true })
        keymap("x", "g<C-a>", dial_map.inc_gvisual("mygroup"), { noremap = true })
        keymap("x", "g<C-x>", dial_map.dec_gvisual("mygroup"), { noremap = true })

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
                word = false, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "<", ">" },
                word = false, -- 匹配一个单词
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "++", "--" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "!==", "===" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "MAX", "MIN" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "max", "min" },
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
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday",
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun",
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "error",
                    "warn",
                    "info",
                    "debug",
                    "trace",
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
                    "ten",
                },
                word = true,
                cyclic = true,
            }),
            augend.hexcolor.new({
                case = "lower",
            }),
            augend.constant.new({
                elements = { "!=", "==" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "left", "right" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "up", "down" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "FIX",
                    "TODO",
                    "HACK",
                    "WARN",
                    "PERF",
                    "NOTE",
                    "TEST",
                    "SAFETY",
                },
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
