---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

local crates = {
    "actix-web",
    "ansi_term",
    "anyhow", -- 错误处理
    "approx", -- 近似浮点数比较
    "async-std", -- async
    "axum",
    "base64",
    "bitflags",
    "byteorder",
    "cc",
    "chrono", -- 时间
    "clap",
    "criterion",
    "crossbeam", -- 并发
    "crossbeam-channel",
    "crossterm", -- 终端后端
    "csv",
    "cursive", -- tui
    "data-encoding", -- sha-256
    "digest", -- sha-256
    "dioxus",
    "flame",
    "flate2", -- 压缩包
    "futures",
    "glob",
    "lazy_static", -- 并发
    "memmap",
    "metrics",
    "mio",
    "mysql", -- 数据库
    "mysql_async", -- 数据库
    "ndarray", -- 矩阵
    "num",
    "num_cpus", -- 获取cpu核心数量
    "opentelementry",
    "parking_lot",
    "percent-encoding",
    "plotters",
    "postgres",
    "rand", -- rnadom
    "rand_distr", -- random
    "rbatis",
    "redis-rs",
    "regex", -- 正则
    "reqwest",
    "ring", -- 加密
    "rocket",
    "rusqlite", -- 数据库
    "same_file",
    "serde", -- 序列化
    "serde_json", -- 序列化
    "serde_yaml", -- 序列化
    "sqlx", -- 数据库
    "tar", -- 压缩包
    "thiserror", -- 错误处理
    "tokio", -- async
    "toml", -- 序列化
    "tracing", -- log
    "tui", -- tui
    "unicode-segmentation",
    "url",
    "x11rb",
    "wayland-client",
    "walkdir", -- 遍历目录
}

local snippets = {}

for _, crate in pairs(crates) do
    table.insert(
        snippets,
        s(
            {
                trig = crate,
                priority = 30000,
            },
            fmt(crate .. [[ = { version = "<>" }]], {
                i(1, ""),
            }, { delimiters = "<>" })
        )
    )
end

return snippets
