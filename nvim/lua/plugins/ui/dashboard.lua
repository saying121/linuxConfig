local vfn = vim.fn
local M = {}

--- 在表的长度里面随机取值
---@param the_list table
---@return integer
function M.get_rand(the_list)
    -- return math.random(1, #the_list)
    return vfn.rand() % #the_list + 1
end

--- 获取文件路径
---@param dir_name string
---@return string
function M.get_random_file_path(dir_name)
    local dir_path = vfn.stdpath("config") .. "/dashboard/" .. dir_name
    local file_name = vfn.readdir(dir_path)
    -- file_name = { 'dinosaur.cat' } -- 测试某个
    return dir_path .. "/" .. file_name[M.get_rand(file_name)]
end

local utils = require("public.utils")
local split = 28
local split1 = 25
local total = split + split1
local result = vfn.rand() % total
-- result = 1
-- result = 60
local cond = vfn.argc() == 0 and result < split

---@type LazySpec
return {
    {
        "glepnir/dashboard-nvim",
        cond = cond,
        config = function()
            local path_cat = M.get_random_file_path("the_cat")
            local all_prev = {
                {
                    file_path = path_cat,
                    command = "cat | lolcat ",
                    file_height = 24,
                    file_width = utils.get_columns(path_cat),
                },
                {
                    file_path = M.get_random_file_path("pictures"),
                    -- command = "chafa -C on -c full --fg-only --symbols braille ",
                    command = "chafa --passthrough=tmux --format=symbols --stretch --align center -c full",
                    file_height = 24,
                    file_width = 45,
                },
            }

            local use_prev
            if vfn.getenv("TERM") == "xterm-kitty" then
                use_prev = all_prev[M.get_rand(all_prev)]
            else
                use_prev = all_prev[1]
            end

            require("dashboard").setup({
                center = true,
                vertical_center = true,
                theme = "doom",
                preview = use_prev,
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
                            icon = "󰈢  ",
                            icon_hl = "DashBoardIcon",
                            desc = "New file                        ",
                            desc_hl = "DashBoardCenter",
                            key = "n",
                            key_hl = "DashBoardShortCut",
                            action = "<cmd>ene <BAR> startinsert <CR>",
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
                            icon = "󰗼  ",
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
        init = function()
            local api = vim.api
            api.nvim_create_autocmd({ "FileType" }, {
                group = api.nvim_create_augroup("NoCursorline", { clear = false }),
                pattern = { "dashboard", "alpha" },
                command = "setlocal nocursorline",
            })
        end,
        cond = not cond,
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local buttons = {
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
            local pic_cat = M.get_random_file_path("pictures")
            local dynamic_header = {
                type = "terminal",
                command = "chafa --passthrough=tmux --format=symbols --stretch --align center -c full " .. pic_cat,
                -- command = "chafa -C on -c full --fg-only --symbols braille " .. pic_cat,
                -- command = "chafa -C true -f sixel -w 9 -s 30 x 40 " .. pic_cat..redirect,
                width = 50,
                height = 30,
                opts = {
                    position = "center",
                    redraw = true,
                    window_config = {},
                },
            }

            local path_cat = M.get_random_file_path("alpha")
            local lolcat_header = {
                type = "terminal",
                command = "cat " .. path_cat .. " | lolcat ",
                width = utils.get_columns(path_cat),
                height = utils.get_lines(path_cat),
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
            local vson = vim.version()
            local version = "  󰥱 v" .. vson.major .. "." .. vson.minor .. "." .. vson.patch
            local footer = {
                type = "text",
                val = "Neovim " .. version .. "  " .. stats.count .. " plugins ",
                opts = {
                    position = "center",
                    hl = "Number",
                },
            }
            local prev
            if vfn.getenv("TERM") == "xterm-kitty" then
                prev = all_prev[M.get_rand(all_prev)]
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
