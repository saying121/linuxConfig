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

local tb = {
    feat = "新功能",
    fix = "修复bug， 产生diff并自动修复此问题。适合于一次提交直接修复问题",
    to = "修复bug，只产生diff不自动修复此问题。适合于多次提交。最终修复问题提交时使用fix",
    docs = "文档",
    style = "格式（不影响代码运行的变动）。",
    refactor = "重构（即不是新增功能，也不是修改bug的代码变动）。",
    perf = "优化相关，比如提升性能、体验。",
    test = "增加测试。",
    chore = "构建过程或辅助工具的变动。",
    revert = "回滚到上一个版本。",
    merge = "代码合并。",
    sync = "同步主线或分支的Bug。",
    build = "影响项目构建或依赖项修改",
    ci = "持续集成相关文件修改",
    release = "发布新版本",
    workflow = "工作流相关文件修改",
    publish = "发布新版本",
}

local snippets = {
    s(
        {
            trig = "break",
            priority = 30000,
            dscr = "不兼容的变化",
        },
        fmta("<>: <>", {
            i(1, "BREAKING CHANGE"),
            i(2, "title"),
        })
    ),
}
for name, describe in pairs(tb) do
    table.insert(
        snippets,
        s(
            {
                trig = name,
                priority = 30000,
                dscr = describe,
            },
            fmta(name .. "(<>): <>", {
                i(1, "scope"),
                i(2, "title"),
            })
        )
    )
end

return snippets
