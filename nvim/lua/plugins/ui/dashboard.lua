local dash_func = require("public.dashboard")
local split = 41
local split1 = 26
local total = split + split1
local result = vim.fn.rand() % total
-- result = 1
result = 60

--- 是否启用
---@return boolean
local function enable_cond()
    -- 判断命令行启动有几个参数
    if vim.fn.exists("neovide") ~= 0 and #vim.v.argv <= 3 then
        return true
    else
        return false
    end
end

return {
    {
        "glepnir/dashboard-nvim",
        cond = function()
            local cond = result < split
            if enable_cond() then
                return cond
            end
            return #vim.v.argv <= 2 and cond
        end,
        config = function()
            local path_cat = dash_func.get_random_file_path("the_cat")
            local all_prev = {
                {
                    path = path_cat,
                    command = "cat | lolcat ",
                    file_height = 24,
                    file_width = dash_func.get_columns(path_cat),
                },
                {
                    path = dash_func.get_random_file_path("pictures"),
                    command = "chafa -C on -c full --fg-only --symbols braille ",
                    file_height = 24,
                    file_width = 45,
                },
            }

            local rand = dash_func.get_rand(all_prev)
            rand = 1
            local use_prev = all_prev[rand]

            require("dashboard").setup({
                theme = "doom",
                preview = {
                    command = use_prev["command"],
                    file_path = use_prev["path"],
                    file_height = use_prev["file_height"],
                    file_width = use_prev["file_width"],
                },
                config = {
                    -- header = '',
                    week_header = {
                        enable = true,
                        concat = "",
                        append = {},
                    },
                    -- disable_move = true,
                    center = {
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Recently opened files           ",
                            desc_hl = "DashBoardCenter",
                            key = "r",
                            key_hl = "DashBoardShortCut",
                            action = "Telescope oldfiles",
                        },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Find File                     ",
                            desc_hl = "DashBoardCenter",
                            key = "f",
                            key_hl = "DashBoardShortCut",
                            action = "Telescope find_files find_command=rg,--hidden,--files",
                        },
                        {
                            icon = "󰒲  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Lazy                            ",
                            desc_hl = "DashBoardCenter",
                            key = "l",
                            key_hl = "DashBoardShortCut",
                            action = "Lazy",
                        },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Edit config                     ",
                            desc_hl = "DashBoardCenter",
                            key = "c",
                            key_hl = "DashBoardShortCut",
                            action = "e $MYVIMRC",
                        },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Exit                            ",
                            desc_hl = "DashBoardCenter",
                            key = "q",
                            key_hl = "DashBoardShortCut",
                            action = "x",
                        },
                    },
                    -- footer = {require("lazy").stats().count},
                },
            })
        end,
    },
    {
        "goolord/alpha-nvim",
        cond = function()
            local cond = result >= split
            if enable_cond() then
                return cond
            end
            return #vim.v.argv <= 2 and cond
        end,
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local buttons = {
                dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
                dashboard.button("n", " " .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
                dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC <CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", "<cmd>Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", "<cmd>qa<CR>"),
            }
            dashboard.section.buttons.val = buttons
            for _, button in ipairs(buttons) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            local button = {
                type = "group",
                val = buttons,
                opts = { spacing = 1 },
            }

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"

            -- Config gif header
            require("alpha.term")

            -- local redirect = " > /proc/" .. vim.loop.os_getpid() .. "/fd/1"
            local pic_cat = dash_func.get_random_file_path("pictures")
            local dynamic_header = {
                type = "terminal",
                command = "chafa -C on -c full --fg-only --symbols braille " .. pic_cat,
                -- command = "chafa -C true -f sixel -w 9 -s 30 x 40 " .. pic_cat..redirect,
                width = 190,
                height = 20,
                opts = {
                    position = "center",
                    redraw = true,
                    window_config = {},
                },
            }

            local path_cat = dash_func.get_random_file_path("alpha")
            local lolcat_header = {
                type = "terminal",
                command = "cat " .. path_cat .. " | lolcat ",
                width = dash_func.get_columns(path_cat),
                height = dash_func.get_lines(path_cat),
                opts = {
                    position = "center",
                    redraw = true,
                    window_config = {},
                },
            }
            local all_prev = {
                lolcat_header,
                dynamic_header,
            }

            -- Obtain Date Info
            local date = io.popen('echo "$(date +%a) $(date +%b) $(date +%d)" | tr -d "\n"')
            ---@diagnostic disable-next-line: need-check-nil
            local date_info = "󰨲 Today is " .. date:read("*a")
            ---@diagnostic disable-next-line: need-check-nil
            date:close()

            local date_today = {
                type = "text",
                val = date_info,
                opts = {
                    position = "center",
                    hl = "Keyword",
                },
            }

            local stats = require("lazy").stats()
            local version = "  󰥱 v"
                .. vim.version().major
                .. "."
                .. vim.version().minor
                .. "."
                .. vim.version().patch
            local footer = {
                type = "text",
                val = "Neovim " .. version .. "  " .. stats.count .. " plugins ",
                opts = {
                    position = "center",
                    hl = "Number",
                },
            }
            local prev
            if vim.fn.getenv("TERM") == "xterm-kitty" then
                prev = all_prev[dash_func.get_rand(all_prev)]
            else
                prev = all_prev[1]
            end

            dashboard.opts = {
                layout = {
                    { type = "padding", val = 0 },
                    prev,
                    { type = "padding", val = 7 },
                    date_today,
                    { type = "padding", val = 2 },
                    button,
                    { type = "padding", val = 1 },
                    footer,
                    -- { type = "padding", val = 1 },
                },
                opts = {
                    margin = 0,
                    noautocmd = false,
                    redraw_on_resize = true,
                },
            }

            alpha.setup(dashboard.opts)
        end,
    },
}
