local keymap = vim.keymap.set
local api = vim.api

---@type LazySpec
return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>", mode = { "n", "x" } },
        { "<C-x>", mode = { "n", "x" } },
    },
    init = function()
        local dial_map = require("dial.map")
        local function mp(group)
            keymap("n", "<C-a>", dial_map.inc_normal(group), { noremap = true })
            keymap("n", "<C-x>", dial_map.dec_normal(group), { noremap = true })
            keymap("n", "g<C-a>", dial_map.inc_gnormal(group), { noremap = true })
            keymap("n", "g<C-x>", dial_map.dec_gnormal(group), { noremap = true })

            keymap("x", "<C-a>", dial_map.inc_visual(group), { noremap = true })
            keymap("x", "<C-x>", dial_map.dec_visual(group), { noremap = true })
            keymap("x", "g<C-a>", dial_map.inc_gvisual(group), { noremap = true })
            keymap("x", "g<C-x>", dial_map.dec_gvisual(group), { noremap = true })
        end

        api.nvim_create_autocmd({ "BufEnter" }, {
            group = api.nvim_create_augroup("DialKeymap", { clear = true }),
            pattern = { "*" },
            callback = function()
                if vim.bo.ft == "lua" then
                    mp("lua")
                else
                    mp("default")
                end
            end,
        })
    end,
    config = function()
        local augend = require("dial.augend")
        local config = require("dial.config")

        local default = {
            augend.integer.alias.decimal,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha,
            augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.integer.new({
                radix = 16,
                prefix = "0x",
                natural = true,
                case = "upper",
            }),
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

        local other = vim.deepcopy(default)
        table.insert(
            other,
            augend.constant.new({
                elements = { "==", "!=" },
                word = false,
                cyclic = true,
            })
        )

        local lua = default
        table.insert(
            lua,
            augend.constant.new({
                elements = { "==", "~=" },
                word = false,
                cyclic = true,
            })
        )

        config.augends:register_group({
            default = other,
            lua = lua,
        })
    end,
}
