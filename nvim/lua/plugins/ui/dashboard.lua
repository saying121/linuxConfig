return {
    "glepnir/dashboard-nvim",
    cond = function()
        -- 判断命令行启动有几个参数，第一个是nvim,第二个一般是文件名
        if vim.fn.exists("neovide") ~= 0 and #vim.v.argv == 3 then
            return true
        end
        return #vim.v.argv <= 2 or false
    end,
    config = function()
        local function file_exists(file)
            local f = io.open(file, "rb")
            if f then
                f:close()
            end
            return f ~= nil
        end

        -- 从一个文件中读取所有的行，并返回一个包含所有行的表
        local function lines_from(file)
            if not file_exists(file) then
                return {}
            end

            local lines = {}

            for line in io.lines(file) do
                lines[#lines + 1] = line
            end
            return lines
        end

        -- 获取一个文件的行数
        local function get_lines(file)
            local lines = lines_from(file)
            local num_lines = #lines -- 表的长度就是行数
            return num_lines
        end
        -- 获取一个文件的最大列数
        local function get_columns(file)
            local lines = lines_from(file)

            local max_columns = 0 -- 初始化最大列数为0
            for _, line in ipairs(lines) do -- 遍历每一行
                local num_columns = #line -- 字符串的长度就是列数
                if num_columns > max_columns then -- 如果当前行的列数大于最大列数，就更新最大列数
                    max_columns = num_columns
                end
            end
            print(max_columns)

            return max_columns -- 最大列数
        end

        -- lua5.1 / luajit2.1 随机数有bug
        local function get_rand(the_list)
            -- return math.random(1, #the_list)
            return vim.fn.rand() % #the_list + 1
        end

        -- 获取文件路径
        local function get_random_file_path(dir_name)
            local dir_path = vim.fn.stdpath("config") .. "/dashboard/" .. dir_name
            local file_name = vim.fn.readdir(dir_path)
            -- local file_name = { 'ARCHlabs.cat' } -- 测试某个
            return dir_path .. "/" .. file_name[get_rand(file_name)]
        end

        local path_cat = get_random_file_path("the_cat")
        local all_prev = {
            {
                path = path_cat,
                command = "cat | lolcat -F 0.3",
                file_height = 24,
                file_width = get_columns(path_cat),
            },
            {
                path = get_random_file_path("pictures"),
                command = "chafa",
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
                        action = [[=require'toggleterm.terminal'.Terminal:new({ cmd = 'ranger' }):toggle()]],
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
