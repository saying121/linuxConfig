local get_info = require("public.get_some_info")
---@type LazySpec
return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    priority = 500,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local function rime_status()
            if vim.g.rime_enabled then
                return "ㄓ"
            else
                return ""
            end
        end

        local function mode()
            local modestr = require("noice").api.status.mode.get()
            local str, _ = string.gsub(modestr, "%W", "")
            return str
        end

        local function dbui_statusline()
            return vim.g.loaded_dbui
                    and vim.fn["db_ui#statusline"]({
                        prefix = "DB: ",
                        separator = " -> ",
                        show = { "db_name", "schema", "table" },
                    })
                or ""
        end

        local function dbui_query()
            vim.fn["db_ui#query"]({})
        end

        local function rs_target()
            local config = vim.lsp.get_clients({ name = "rust-analyzer" })
            ---@diagnostic disable-next-line: undefined-field
            local target = config[1].config.default_settings["rust-analyzer"].cargo.target
            local info = get_info.parse_rustc_version()
            if not info then
                return target
            end
            target = target or info.host

            local is_nightly = string.find(info.release, "nightly") ~= nil
            if is_nightly then
                return target .. "-" .. info.release
            else
                return target
            end
        end

        local function dbui_connections()
            local list = vim.fn["db_ui#connections_list"]()
            local conn = ""
            -- v:
            -- {
            --      is_connected = 0, -- 0 or 1
            --      name = "bakeries_db",
            --      source = "file",
            --      url = "mysql://user:1234567@127.0.0.1:3306/bakeries_db"
            -- }
            for _, v in ipairs(list) do
                if v.is_connected then
                    if conn == "" then
                        conn = v.name
                    else
                        conn = conn .. "," .. v.name
                    end
                end
            end

            return conn
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                -- component_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "dashboard", "alpha" },
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = {
                    -- "mode",
                    {
                        mode,
                        cond = require("noice").api.status.mode.has,
                        color = { fg = "#000000" },
                        -- color = { fg = "ff9e64" },
                    },
                },
                lualine_b = {
                    "branch",
                    "diagnostics",
                    {
                        dbui_statusline,
                        icon = "",
                        color = { bg = "#0d1d47" },
                    },
                    -- dbui_query,
                    -- dbui_connections,
                },
                lualine_c = {
                    {
                        "filesize",
                        color = { bg = "#0a2447" },
                        icon = "",
                        -- color = { bg = "#0a1d47" },
                    },
                    {
                        "filename",
                        file_status = true, -- Displays file status (readonly status, modified status)
                        newfile_status = true, -- Display new file status (new file means no write after created)
                        path = 3, -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                    },
                },
                lualine_x = {
                    { "%M" },
                    {
                        require("noice").api.status.command.get,
                        cond = require("noice").api.status.command.has,
                        -- color = { fg = "ff9e64" },
                    },
                    {
                        "rest",
                        cond = function()
                            return vim.bo.ft == "http"
                        end,
                    },
                    { rime_status },
                    {
                        "filetype",
                        colored = true, -- Displays filetype icon in color if set to true
                        icon_only = false, -- Display only an icon for filetype
                        icon = { align = "left" }, -- Display filetype icon on the right hand side
                        -- icon =    {'X', align='right'}
                        -- Icon string ^ in table is ignored in filetype component
                    },
                    {
                        rs_target,
                        cond = function()
                            return vim.bo.filetype == "rust"
                        end,
                    },
                    {
                        "lsp_status",
                        icon = " :",
                    },
                },
                lualine_y = {
                    "encoding",
                    {
                        "fileformat",
                        symbols = {
                            unix = "",
                            dos = "",
                            mac = "",
                        },
                    },
                },
                lualine_z = { "location", "%L" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {
                "lazy",
                "trouble",
                "neo-tree",
                "nvim-tree",
                "quickfix",
                "toggleterm",
                "nvim-dap-ui",
                "man",
                "aerial",
                "oil",
                -- "mason",
            },
        })
    end,
}
