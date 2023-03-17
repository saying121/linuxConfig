return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local function get_distro()
            local file = io.open("/etc/os-release", "r")
            if file then
                for line in file:lines() do
                    if line:match("^ID=") then
                        return line:gsub("ID=", ""):gsub('"', "")
                    end
                end
                file:close()
            end
            return nil
        end

        local function linux_distro()
            if os.getenv("TERMUX_VERSION") ~= nil then
                return "OS:"
            end

            local distro = {
                arch = "",
                kali = "",
                ubuntu = "",
                suse = "",
                manjaro = "",
                pop = "",
            }

            local uname = vim.loop.os_uname()
            if uname.sysname == "Linux" then
                local your_distro = get_distro()

                if distro[your_distro] ~= nil then
                    return "OS:" .. distro[your_distro]
                else
                    return "OS:" .. "Linux"
                end
            end

            if vim.fn.has("win") then
                return "OS:"
            elseif vim.fn.has("mac") then
                return "OS:"
            end

            return uname.sysname
        end

        local function lsp_clients()
            local msg = "No Active Lsp"
            -- local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local buf_ft = vim.bo.ft
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
                return msg
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
            return msg
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "dashboard" },
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                -- lualine_a = { "mode" },
                lualine_a = {
                    {
                        require("noice").api.statusline.mode.get,
                        cond = require("noice").api.statusline.mode.has,
                        color = { fg = "#000000" },
                        -- color = { fg = "ff9e64" },
                    },
                },
                lualine_b = { "branch", "diagnostics" },
                lualine_c = {
                    "%.50F",
                },
                lualine_x = {
                    "%M",
                    {
                        require("noice").api.status.message.get_hl,
                        cond = require("noice").api.status.message.has,
                    },
                    "filetype",
                    {
                        lsp_clients,
                        -- icon = " LSP:",
                        icon = " :",
                    },
                    "encoding",
                    "fileformat",
                    linux_distro,
                },
                lualine_y = { "location", "%L" },
                lualine_z = { "progress" },
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
            extensions = {},
        })
        vim.opt.laststatus = 3
    end,
}
