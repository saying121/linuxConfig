return {
    pylsp = {
        plugins = {
            flake8 = {
                enabled = false,
            },
            autopep8 = {
                enabled = false,
            },
            -- jedi = {
            --     auto_import_moduls = { 'numpy', 'math' },
            -- },
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
