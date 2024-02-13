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

local ext_opts = {
    -- these ext_opts are applied when the node is active (e.g. it has been
    -- jumped into, and not out yet).
    -- this is the table actually passed to `nvim_buf_set_extmark`.
    active = {
        -- highlight the text inside the node red.
        hl_group = "Error",
    },
    -- these ext_opts are applied when the node is not active, but
    -- the snippet still is.
    passive = {
        -- add virtual text on the line of the node, behind all text.
        virt_text = { { "virtual text!!", "WarningMsg" } },
    },
    -- and these are applied when both the node and the snippet are inactive.
    snippet_passive = {},
}

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function(ctype)
    -- use the `Comments.nvim` API to fetch the comment string for the region (eq. '--%s' or '--[[%s]]' for `lua`)
    local cstring = calculate_comment_string({ ctype = ctype, range = utils.get_region() }) or vim.bo.commentstring
    -- as we want only the strings themselves and not strings ready for using `format` we want to split the left and right side
    local left, right = utils.unwrap_cstr(cstring)
    -- create a `{left, right}` table for it
    return { left, right }
end

local function create_box(opts)
    local pl = opts.padding_length or 4
    local function pick_comment_start_and_end()
        -- because lua block comment is unlike other language's,
        --  so handle lua ctype
        local ctype = 2
        if vim.opt.ft:get() == "lua" then
            ctype = 1
        end
        local cs = get_cstring(ctype)[1]
        local ce = get_cstring(ctype)[2]
        if ce == "" or ce == nil then
            ce = cs
        end
        return cs, ce
    end
    return {
        -- top line
        f(function(args)
            local cs, ce = pick_comment_start_and_end()
            return cs .. string.rep(string.sub(cs, #cs, #cs), string.len(args[1][1]) + 2 * pl) .. ce
        end, { 1 }),
        t({ "", "" }),
        f(function()
            local cs = pick_comment_start_and_end()
            return cs .. string.rep(" ", pl)
        end),
        i(1, "box"),
        f(function()
            local cs, ce = pick_comment_start_and_end()
            return string.rep(" ", pl) .. ce
        end),
        t({ "", "" }),
        -- bottom line
        f(function(args)
            local cs, ce = pick_comment_start_and_end()
            return cs .. string.rep(string.sub(ce, 1, 1), string.len(args[1][1]) + 2 * pl) .. ce
        end, { 1 }),
    }
end

local function box(opts)
    local function box_width()
        return opts.box_width or vim.opt.textwidth:get()
    end

    local function padding(cs, input_text)
        local spaces = box_width() - (2 * #cs)
        spaces = spaces - #input_text
        return spaces / 2
    end

    local comment_string = function()
        return require("luasnip.util.util").buffer_comment_chars()[1]
    end

    return {
        f(function()
            local cs = comment_string()
            return string.rep(string.sub(cs, 1, 1), box_width())
        end, { 1 }),
        t({ "", "" }),
        f(function(args)
            local cs = comment_string()
            return cs .. string.rep(" ", math.floor(padding(cs, args[1][1])))
        end, { 1 }),
        i(1, "placeholder"),
        f(function(args)
            local cs = comment_string()
            return string.rep(" ", math.ceil(padding(cs, args[1][1]))) .. cs
        end, { 1 }),
        t({ "", "" }),
        f(function()
            local cs = comment_string()
            return string.rep(string.sub(cs, 1, 1), box_width())
        end, { 1 }),
    }
end

return {
    -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#box-comment-like-ultisnips
    s({ trig = "box_" }, box({ box_width = 24 })),
    s({ trig = "bbox_" }, box({})),
    s({ trig = "box" }, create_box({ padding_length = 8 })),
    s({ trig = "bbox" }, create_box({ padding_length = 18 })),

    s("ext_opt", {
        i(1, "text1", {
            node_ext_opts = ext_opts,
        }),
        t({ "", "" }),
        i(2, "text2", {
            node_ext_opts = ext_opts,
        }),
    }),
    -- s("func", {
    --     i(1, "first1 "),
    --     f(function(args, snip)
    --         return args[1][1] .. "" .. args[1][2] .. args[2][1] .. " end"
    --     end, { ai[2], ai[1] }),
    --     i(2, { "second2 ", "return3 ", " 1 " }),
    -- }),
    -- s("abs", {
    --     i(1, "text_of_first "),
    --     i(2, { "first_line_of_second", "second_line_of_second" }),
    --     f(function(args, snip)
    --         return args[1][1] .. args[2][1]
    --     end, { 2, 1 }),
    -- }),
    -- postfix(".br", {
    --     f(function(_, parent)
    --         return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]"
    --     end, {}),
    -- }),
    -- postfix(".brl", {
    --     l("[" .. l.POSTFIX_MATCH .. "]"),
    -- }),
    -- postfix({ trig = ".brd" }, {
    --     d(1, function(_, parent)
    --         return sn(nil, { t("[" .. parent.env.POSTFIX_MATCH .. "]") })
    --     end),
    -- }),
    -- s(
    --     "trig6",
    --     c(1, {
    --         t("ugh boring ,a node"),
    --         i(nil, "edit something..."),
    --         f(function(args)
    --             return "stell text"
    --         end, {}),
    --     })
    -- ),
    -- s(
    --     "trig7",
    --     sn(1, {
    --         t("basicall"),
    --         i(1, "and"),
    --     })
    -- ),
    -- s("isn", {
    --     isn(1, {
    --         t({ "indented as deep trigger", "and next line" }),
    --     }, ""),
    -- }),
    -- s("isn2", {
    --     isn(1, t({ "//This is", "A multiline", "comment" }), "$PARENT_INDENT//"),
    -- }),
    -- s("trig8", {
    --     t("text: "),
    --     i(1),
    --     t({ "", "copy: " }),
    --     d(2, function(args)
    --         -- the returned snippetNode doesn't need a position; it's inserted
    --         -- "inside" the dynamicNode.
    --         return sn(nil, {
    --             -- jump-indices are local to each snippetNode, so restart at 1.
    --             i(1, args[1]),
    --         })
    --     end, { 1 }),
    -- }),
}
