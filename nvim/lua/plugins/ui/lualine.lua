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

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                -- component_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "dashboard" },
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
                        -- require("noice").api.status.mode.get,
                        mode,
                        cond = require("noice").api.status.mode.has,
                        color = { fg = "#000000" },
                        -- color = { fg = "ff9e64" },
                    },
                },
                lualine_b = { "branch", "diagnostics" },
                lualine_c = {
                    {
                        "filesize",
                        color = { bg = "#0a1d47" },
                    },
                    {
                        "filename",
                        file_status = true, -- Displays file status (readonly status, modified status)
                        newfile_status = false, -- Display new file status (new file means no write after created)
                        path = 3, -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory

                        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                        -- for other components. (terrible name, any suggestions?)
                        symbols = {
                            modified = "[+]", -- Text to show when the file is modified.
                            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                            unnamed = "[No Name]", -- Text to show for unnamed buffers.
                            newfile = "[New]", -- Text to show for newly created file before first write
                        },
                    },
                },
                lualine_x = {
                    -- {
                    --     require("noice").api.status.message.get_hl,
                    --     cond = require("noice").api.status.message.has,
                    -- },
                    -- {
                    --     require("noice").api.status.search.get,
                    --     cond = require("noice").api.status.search.has,
                    --     color = { fg = "ff9e64" },
                    -- },
                    { "%M" },
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
                        require("public.get_some_info").lsp_clients,
                        -- icon = " LSP:",
                        icon = " :",
                    },
                    "encoding",
                    "fileformat",
                },
                lualine_y = {
                    require("public.get_some_info").linux_distro,
                },
                lualine_z = {
                    "location",
                    "%L",
                    -- "progress",
                },
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
            },
        })

        -- vim.opt.laststatus = 3
    end,
}
