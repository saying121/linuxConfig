---@type LazySpec
return {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
        vim.keymap.set("n", "<leader><leader>d", "<cmd>DBUIToggle<cr>", { noremap = true, silent = true })

        vim.g.db_ui_save_location = "~/.local/share/db_ui"

        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_tmp_query_location = "~/sql"
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_execute_on_save = 0
        vim.g.db_ui_use_nvim_notify = 1
        vim.g.db_ui_debug = 0
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_auto_execute_table_helpers = 0

        -- :h Db_ui_buffer_name_generator
        vim.g.Db_ui_buffer_name_generator = function(opt)
            local time = vim.fn.strftime("%Y-%m-%d")
            if opt.label == nil then
                return time
            end
            return opt.table .. "-" .. opt.label .. "-" .. time .. "." .. opt.filetype
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
        -- vim.fn['db_ui#connections_list']()
        -- vim.fn["db_ui#statusline"]({
        --     prefix = "DB: ",
        --     separator = " -> ",
        --     show = { "db_name", "schema", "table" },
        -- })
        local function gen_insert()
            local table_name = vim.b.dbui_table_name or ""
            local query_str

            if string.len(table_name) == 0 then
                table_name = vim.fn.input("Enter table name:", "")
                query_str = string.format(
                    "SELECT column_name, data_type FROM information_schema.columns WHERE table_name='%s'",
                    table_name
                )
            else
                query_str = string.format(
                    "SELECT column_name, data_type FROM information_schema.columns WHERE table_name='%s' AND table_schema='%s'",
                    table_name,
                    vim.b.dbui_schema_name
                )
            end

            ---@type table<integer, string[]>
            local rows = vim.fn["db_ui#query"](query_str)
            local len = #rows

            ---@type string|table
            local lines = "INSERT INTO " .. table_name .. " (\n"
            ---@type string
            local last = ") VALUES (\n"

            for index, val in pairs(rows) do
                if index == len then
                    lines = lines .. "    " .. val[1] .. "\n"
                    last = last .. string.format("    %s <%s> \n", val[1], val[2])
                else
                    lines = lines .. "    " .. val[1] .. ",\n"
                    last = last .. string.format("    %s <%s> ,\n", val[1], val[2])
                end
            end

            lines = lines .. last .. ");"
            lines = vim.split(lines, "\n")

            local line_count = vim.api.nvim_buf_line_count(0)

            vim.api.nvim_buf_set_lines(0, line_count, line_count, false, lines)
        end

        vim.keymap.set("n", "<leader>is", gen_insert)
    end,
}
