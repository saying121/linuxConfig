return {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
        vim.cmd([[highlight DashBoardFooter gui=italic guibg=NONE cterm=NONE guifg=Cyan ctermfg=NONE]])
        vim.cmd([[highlight DashBoardShortCut gui=italic guibg=NONE cterm=NONE guifg=DarkCyan ctermfg=NONE]])
        vim.cmd([[highlight DashBoardCenter gui=italic guibg=NONE cterm=NONE guifg=DarkCyan ctermfg=NONE]])
        -- lua5.1 / luajit2.1 随机数有bug
        local function get_rand(the_list)
            -- return math.random(1, #the_list)
            return vim.fn.rand() % #the_list + 1
        end

        local function get_random_file_path(dir_name)
            local dir_path = vim.fn.stdpath("config") .. "/dashboard/" .. dir_name
            local file_name = vim.fn.readdir(dir_path)
            -- local file_name = { 'hydra.cat' } -- 测试某个
            return dir_path .. "/" .. file_name[get_rand(file_name)]
        end

        local all_prev = {
            {
                path = get_random_file_path("the_cat"),
                command = "cat | lolcat -F 0.3",
                file_height = 24,
                file_width = 100,
            },
            {
                path = get_random_file_path("pictures"),
                command = "", -- 等可以显示图片再添加command
                file_height = 24,
                file_width = 60,
            },
        }

        local rand = get_rand(all_prev)
        rand = 1

        require("dashboard").setup({
            theme = "doom",
            preview = {
                command = all_prev[rand]["command"],
                file_path = all_prev[rand]["path"],
                file_height = all_prev[rand]["file_height"],
                file_width = all_prev[rand]["file_width"],
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
                        icon_hl = "group",
                        desc = "Recently opened files       ",
                        desc_hl = "group",
                        key = "|",
                        key_hl = "",
                        action = "Telescope oldfiles",
                    },
                    {
                        icon = "  ",
                        icon_hl = "group",
                        desc = "Find File                   ",
                        desc_hl = "group",
                        key = "|",
                        key_hl = "",
                        action = "Telescope find_files find_command=rg,--hidden,--files",
                    },
                    {
                        icon = "  ",
                        icon_hl = "group",
                        desc = "File Browser                ",
                        desc_hl = "group",
                        key = "|",
                        key_hl = "",
                        action = "Lspsaga term_toggle ranger",
                    },
                    -- { icon = '  ', icon_hl = 'group', desc = 'File Browser                ', desc_hl = 'group',
                    --     key = '|',
                    --     key_hl = '', action = 'FloatermNew --height=0.8 --width=0.8 ranger'
                    -- },
                    {
                        icon = "  ",
                        icon_hl = "group",
                        desc = "Edit config                 ",
                        desc_hl = "group",
                        key = "|",
                        key_hl = "",
                        action = "e $MYVIMRC",
                    },
                    {
                        icon = "  ",
                        icon_hl = "group",
                        desc = "Exit                        ",
                        desc_hl = "group",
                        key = "|",
                        key_hl = "",
                        action = "x",
                    },
                },
                -- footer = footer1,
            },
        })
    end,
}
