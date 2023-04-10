return {
    "glepnir/dashboard-nvim",
    cond = function()
        -- 判断命令行启动有几个参数，第一个是nvim,第二个一般是文件名
        if vim.fn.exists("neovide") ~= 0 then
            return true
        end
        if #vim.v.argv <= 2 then
            return true
        end
        return false
    end,
    config = function()
        -- lua5.1 / luajit2.1 随机数有bug
        local function get_rand(the_list)
            -- return math.random(1, #the_list)
            return vim.fn.rand() % #the_list + 1
        end

        local function get_random_file_path(dir_name)
            local dir_path = vim.fn.stdpath("config") .. "/dashboard/" .. dir_name
            local file_name = vim.fn.readdir(dir_path)
            -- local file_name = { 'gura3.cat' } -- 测试某个
            return dir_path .. "/" .. file_name[get_rand(file_name)]
        end

        local all_prev = {
            {
                path = get_random_file_path("the_cat"),
                command = "cat | lolcat -F 0.3",
                file_height = 24,
                file_width = 200,
            },
            {
                path = get_random_file_path("pictures"),
                command = "chafa", -- 等可以显示图片再添加command
                file_height = 24,
                file_width = 45,
            },
        }

        local rand = get_rand(all_prev)
        rand = 1
        local use_prev = all_prev[rand]

        require("dashboard").setup({
            theme = "doom",
            preview = {
                command = use_prev["command"],
                file_path = use_prev["path"],
                -- file_path = os.getenv("HOME") .. "/Pictures/countdown-4173.gif",
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
                        desc = "Recently opened files       ",
                        desc_hl = "DashBoardCenter",
                        key = "|",
                        key_hl = "DashBoardShortCut",
                        action = "Telescope oldfiles",
                    },
                    -- {
                    --     icon = "  ",
                    --     icon_hl = "group",
                    --     desc = "Find File                   ",
                    --     desc_hl = "group",
                    --     key = "|",
                    --     key_hl = "Comment",
                    --     action = "Telescope find_files find_command=rg,--hidden,--files",
                    -- },
                    {
                        icon = "  ",
                        icon_hl = "DashBoardIcon",
                        desc = "Sessions                    ",
                        desc_hl = "DashBoardCenter",
                        key = "|",
                        key_hl = "DashBoardShortCut",
                        action = "SessionManager load_session",
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashBoardIcon",
                        desc = "File Browser                ",
                        desc_hl = "DashBoardCenter",
                        key = "|",
                        key_hl = "DashBoardShortCut",
                        action = "Lspsaga term_toggle ranger",
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashBoardIcon",
                        desc = "Edit config                 ",
                        desc_hl = "DashBoardCenter",
                        key = "|",
                        key_hl = "DashBoardShortCut",
                        action = "e $MYVIMRC",
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashBoardIcon",
                        desc = "Exit                        ",
                        desc_hl = "DashBoardCenter",
                        key = "|",
                        key_hl = "DashBoardShortCut",
                        action = "x",
                    },
                },
                -- footer = footer1,
            },
        })
    end,
}
