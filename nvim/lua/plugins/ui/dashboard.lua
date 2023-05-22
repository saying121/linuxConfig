local dash_func = require("public.dashboard")
local result = vim.fn.rand() % 2
-- result = 1

--- 是否启用
---@param nb number
---@return boolean
local function enable_cond(nb)
    -- 判断命令行启动有几个参数，第一个是nvim,第二个一般是文件名
    if vim.fn.exists("neovide") ~= 0 and #vim.v.argv <= 3 then
        return true
    end
    return #vim.v.argv <= 2 and result == nb
end

return {
    {
        "glepnir/dashboard-nvim",
        cond = enable_cond(0),
        init = function()
            vim.api.nvim_create_autocmd({ "FileType dashboard" }, {
                group = vim.api.nvim_create_augroup("DashboardMap", { clear = true }),
                pattern = { "dashboard" },
                callback = function()
                    local opts1 = { silent = true, noremap = true, buffer = true }
                    local keymap = vim.keymap.set
                    keymap("n", "q", ":x<CR>", opts1)
                end,
            })
        end,
        config = function()
            local path_cat = dash_func.get_random_file_path("the_cat")
            local all_prev = {
                {
                    path = path_cat,
                    command = "cat | lolcat -F 0.3",
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
                            key = "|",
                            key_hl = "DashBoardShortCut",
                            action = "Telescope oldfiles",
                        },
                        -- {
                        --     icon = "  ",
                        --     icon_hl = "group",
                        --     desc = "Find File                     ",
                        --     desc_hl = "group",
                        --     key = "|",
                        --     key_hl = "Comment",
                        --     action = "Telescope find_files find_command=rg,--hidden,--files",
                        -- },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Sessions                        ",
                            desc_hl = "DashBoardCenter",
                            key = "|",
                            key_hl = "DashBoardShortCut",
                            action = "SessionManager load_session",
                        },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "File Browser                    ",
                            desc_hl = "DashBoardCenter",
                            key = "|",
                            key_hl = "DashBoardShortCut",
                            action = [[=require'toggleterm.terminal'.Terminal:new({ cmd = 'ranger' }):toggle()]],
                        },
                        {
                            icon = "  ",
                            icon_hl = "DashBoardIcon",
                            desc = "Edit config                     ",
                            desc_hl = "DashBoardCenter",
                            key = "|",
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
        cond = enable_cond(1),
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local button = {
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                -- dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                dashboard.button("s", " " .. " Session", ":SessionManager load_session<CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            dashboard.section.buttons.val = button
            for _, button in ipairs(button) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            local buttons = {
                type = "group",
                val = button,
                opts = {
                    spacing = 1,
                },
            }

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"

            -- Config gif header
            require("alpha.term")

            local redirect = " > /proc/" .. vim.loop.os_getpid() .. "/fd/1"
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
                command = "cat " .. path_cat .. " | lolcat -F 0.3",
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
            local date = io.popen('echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"')
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

            dashboard.opts = {
                layout = {
                    { type = "padding", val = 0 },
                    all_prev[dash_func.get_rand(all_prev)],
                    { type = "padding", val = 7 },
                    date_today,
                    { type = "padding", val = 2 },
                    buttons,
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

            -- 用 dashboard.opts 改后就不能用这个了
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = version
                        .. "⚡ Neovim loaded "
                        .. stats.count
                        .. " plugins in "
                        .. ms
                        .. "ms"
                    -- vim.cmd("AlphaRedraw")
                    alpha.redraw()
                end,
            })
        end,
    },
}
