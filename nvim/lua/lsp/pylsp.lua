return {
    pylsp = {
        plugins = {
            flake8 = {
                enabled = true,
            },
            autopep8 = {
                enabled = false,
            },
            -- jedi = {
            --     auto_import_moduls = { 'numpy', 'math' },
            -- },
            -- 不提示格式
            pycodestyle = {
                enabled = false,
            },
            yapf = {
                enabled = true,
            },
            rope_autoimport = {
                enabled = false,
                memory = false,
            },
            rope_completion = {
                enabled = false,
                eager = false,
            },
        },
    },
}
