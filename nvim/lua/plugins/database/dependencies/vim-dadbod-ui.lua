return {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
        vim.keymap.set("n", "<leader><leader>d", "<cmd>DBUIToggle<cr>", { noremap = true, silent = true })

        vim.g.db_ui_save_location = "~/.local/share/db_ui"

        vim.g.db_ui_tmp_query_location = "~/sql"
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_execute_on_save = 0
        vim.g.db_ui_use_nvim_notify = 1
        vim.g.db_ui_debug = 0
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_auto_execute_table_helpers = 0

        -- table: label, table, schema, filetype
        vim.g.Db_ui_buffer_name_generator = function(table)
            local time = vim.fn.strftime("%Y-%m-%d")
            if table.label == nil then
                return time
            end
            return table.table .. "-" .. table.label .. "-" .. time .. "." .. table.filetype
        end

        vim.g.db_ui_icons = {
            expanded = {
                db = "▾ ",
                buffers = "▾ ",
                saved_queries = "▾ ",
                schemas = "▾ ",
                schema = "▾ פּ",
                tables = "▾ 藺", -- ﴶ
                table = "▾ ",
            },
            collapsed = {
                db = "▸ ",
                buffers = "▸ ",
                saved_queries = "▸ ",
                schemas = "▸ ",
                schema = "▸ פּ",
                tables = "▸ 藺", -- ﴶ
                table = "▸ ",
            },
            saved_query = "",
            new_query = "璘",
            tables = "離", -- ﴶ
            buffers = "﬘",
            add_connection = "",
            connection_ok = "✓",
            connection_error = "✕",
        }

--         vim.cmd([[
-- function! s:populate_query() abort
--   let rows = db_ui#query(printf(
--     \ "select column_name, data_type from information_schema.columns where table_name='%s' and table_schema='%s'",
--     \ b:dbui_table_name,
--     \ b:dbui_schema_name
--     \ ))
--
--   let lines = ['INSERT INTO '.b:dbui_table_name.' (']
--
--   for [column, datatype] in rows
--     call add(lines, column)
--   endfor
--
--   call add(lines, ') VALUES (')
--
--   for [column, datatype] in rows
--     call add(lines, printf('%s <%s>', column, datatype))
--   endfor
--
--   call add(lines, ')')
--   call setline(1, lines)
-- endfunction
--
-- autocmd FileType sql nnoremap <buffer><leader>is :call <sid>populate_query()
--         ]])
    end,
}
