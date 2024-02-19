local cf = require("public.luasnip_conf")
local choice_popup = cf.choice_popup
local choice_popup_close = cf.choice_popup_close
local update_choice_popup = cf.update_choice_popup

return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp", -- install jsregexp (optional!).
    event = { "InsertEnter" },
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local luasnip, opts = require("luasnip"), { noremap = true, silent = true }
        local keymap = vim.keymap.set

        keymap({ "i", "s" }, "<M-l>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end)
        keymap({ "i", "s" }, "<M-h>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(-1)
            end
        end)
        keymap({ "i", "s" }, "<c-s>", function()
            if luasnip.choice_active() then
                require("luasnip.extras.select_choice")()
            end
        end, opts)

        local types = require("luasnip.util.types")
        local ft_functions = require("luasnip.extras.filetype_functions")
        -- Inserts a insert(1) before all other nodes, decreases node.pos's as indexing is "wrong".
        local function modify_nodes(snip)
            for i = #snip.nodes, 1, -1 do
                snip.nodes[i + 1] = snip.nodes[i]
                local node = snip.nodes[i + 1]
                if node.pos then
                    node.pos = node.pos + 1
                end
            end

            local iNode = require("luasnip.nodes.insertNode")
            snip.nodes[1] = iNode.I(1)
        end

        local default = {
            -- corresponds to legacy "history=false".
            keep_roots = false,
            link_roots = false,
            link_children = false,

            update_events = { "TextChanged", "TextChangedI" },
            -- see :h User, event should never be triggered(except if it is `doautocmd`'d)
            region_check_events = { "CursorMoved", "CursorMovedI" },
            delete_check_events = { "TextChanged" },
            -- store_selection_keys = "<Tab>", -- Supossed to be the same as the expand shortcut
            ext_opts = {
                [types.textNode] = {
                    active = {
                        -- virt_text = { { "●", "TSRainbowOrange" } },
                        hl_group = "LuasnipTextNodeActive",
                    },
                    passive = { hl_group = "LuasnipTextNodePassive" },
                    visited = { hl_group = "LuasnipTextNodeVisited" },
                    unvisited = { hl_group = "LuasnipTextNodeUnvisited" },
                    snippet_passive = { hl_group = "LuasnipTextNodeSnippetPassive" },
                },
                [types.insertNode] = {
                    active = {
                        -- virt_text = { { "●", "GruvboxOrange" } },
                        hl_group = "LuasnipInsertNodeActive",
                    },
                    passive = { hl_group = "LuasnipInsertNodePassive" },
                    visited = { hl_group = "LuasnipInsertNodeVisited" },
                    unvisited = { hl_group = "LuasnipInsertNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipInsertNodeSnippetPassive",
                    },
                },
                [types.exitNode] = {
                    active = { hl_group = "LuasnipExitNodeActive" },
                    passive = { hl_group = "LuasnipExitNodePassive" },
                    visited = { hl_group = "LuasnipExitNodeVisited" },
                    unvisited = { hl_group = "LuasnipExitNodeUnvisited" },
                    snippet_passive = { hl_group = "LuasnipExitNodeSnippetPassive" },
                },
                [types.functionNode] = {
                    active = { hl_group = "LuasnipFunctionNodeActive" },
                    passive = { hl_group = "LuasnipFunctionNodePassive" },
                    visited = { hl_group = "LuasnipFunctionNodeVisited" },
                    unvisited = { hl_group = "LuasnipFunctionNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipFunctionNodeSnippetPassive",
                    },
                },
                [types.snippetNode] = {
                    active = { hl_group = "LuasnipSnippetNodeActive" },
                    passive = { hl_group = "LuasnipSnippetNodePassive" },
                    visited = { hl_group = "LuasnipSnippetNodeVisited" },
                    unvisited = { hl_group = "LuasnipSnippetNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipSnippetNodeSnippetPassive",
                    },
                },
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "●", "TSRainbowOrange" } },
                        hl_group = "LuasnipChoiceNodeActive",
                    },
                    passive = { hl_group = "LuasnipChoiceNodePassive" },
                    visited = { hl_group = "LuasnipChoiceNodeVisited" },
                    unvisited = { hl_group = "LuasnipChoiceNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipChoiceNodeSnippetPassive",
                    },
                },
                [types.dynamicNode] = {
                    active = { hl_group = "LuasnipDynamicNodeActive" },
                    passive = { hl_group = "LuasnipDynamicNodePassive" },
                    visited = { hl_group = "LuasnipDynamicNodeVisited" },
                    unvisited = { hl_group = "LuasnipDynamicNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipDynamicNodeSnippetPassive",
                    },
                },
                [types.snippet] = {
                    active = { hl_group = "LuasnipSnippetActive" },
                    passive = { hl_group = "LuasnipSnippetPassive" },
                    -- not used!
                    visited = { hl_group = "LuasnipSnippetVisited" },
                    unvisited = { hl_group = "LuasnipSnippetUnvisited" },
                    snippet_passive = { hl_group = "LuasnipSnippetSnippetPassive" },
                },
                [types.restoreNode] = {
                    active = { hl_group = "LuasnipRestoreNodeActive" },
                    passive = { hl_group = "LuasnipRestoreNodePassive" },
                    visited = { hl_group = "LuasnipRestoreNodeVisited" },
                    unvisited = { hl_group = "LuasnipRestoreNodeUnvisited" },
                    snippet_passive = {
                        hl_group = "LuasnipRestoreNodeSnippetPassive",
                    },
                },
            },
            ext_base_prio = 200,
            ext_prio_increase = 9,
            enable_autosnippets = false,
            parser_nested_assembler = function(pos, snip)
                -- only require here, to prevent some upfront load-cost.
                local iNode = require("luasnip.nodes.insertNode")
                local cNode = require("luasnip.nodes.choiceNode")

                modify_nodes(snip)
                snip:init_nodes()
                snip.pos = nil

                return cNode.C(pos, { snip, iNode.I(nil, { "" }) })
            end,
            -- Function expected to return a list of filetypes (or empty list)
            ft_func = ft_functions.from_filetype,
            -- fn(bufnr) -> string[] (filetypes).
            load_ft_func = ft_functions.from_filetype_load,
        }
        luasnip.config.setup(default)

        require("luasnip.loaders.from_lua").lazy_load({
            paths = { "~/.config/nvim/lua/snippets" },
            exclude = {},
        })

        require("luasnip.loaders.from_vscode").lazy_load({
            exclude = { "rust", "gitcommit" },
        })

        local gp = vim.api.nvim_create_augroup("choice_popup", { clear = false })
        vim.api.nvim_create_autocmd({ "User" }, {
            group = gp,
            pattern = { "LuasnipChoiceNodeEnter" },
            callback = function()
                choice_popup(luasnip.session.event_node)
            end,
        })
        vim.api.nvim_create_autocmd({ "User" }, {
            group = gp,
            pattern = { "LuasnipChoiceNodeLeave" },
            callback = choice_popup_close,
        })
        vim.api.nvim_create_autocmd({ "User" }, {
            group = gp,
            pattern = { "LuasnipChangeChoice" },
            callback = function()
                update_choice_popup(luasnip.session.event_node)
            end,
        })
    end,
}
