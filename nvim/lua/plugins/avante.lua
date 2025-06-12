return {
    "yetone/avante.nvim",
    keys = {
        { "<leader>aa", mode = { "n", "x" } },
    },
    version = false, -- 永远不要将此值设置为 "*"！永远不要！
    ---@type avante.Config
    opts = {
        provider = "deepseek",
        providers = {
            deepseek = {
                __inherited_from = "openai",
                api_key_name = "DEEPSEEK_API_KEY",
                endpoint = "https://api.deepseek.com",
                -- model = "deepseek-coder",
                model = "deepseek-chat",
            },
        },
    },
    build = "make",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        {
            -- 支持图像粘贴
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- 推荐设置
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- Windows 用户必需
                    use_absolute_path = true,
                },
            },
        },
    },
}
