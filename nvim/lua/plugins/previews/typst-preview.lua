return {
    "niuiic/typst-preview.nvim",
    dependencies = { "niuiic/core.nvim" },
    event = {
        "BufNew *.typ",
        "UIEnter *.typ",
    },
    config = function()
        vim.api.nvim_create_autocmd({ "BufNew", "BufWinEnter", "BufEnter" }, {
            group = vim.api.nvim_create_augroup("TypstPreview", { clear = true }),
            pattern = { "typst", "*.typ" },
            callback = function()
                local opts = { noremap = true, silent = true, buffer = true }

                vim.keymap.set("n", "<c-p>", require("typst-preview").preview, opts)
            end,
        })

        require("typst-preview").setup({
            -- file opened by pdf viewer
            output_file = function()
                local core = require("core")
                return core.file.root_path() .. "/output.pdf"
            end,
            -- how to redirect output files
            redirect_output = function(original_file, output_file)
                vim.cmd(string.format("silent !ln -s %s %s", original_file, output_file))
            end,
            -- how to preview the pdf file
            preview = function(output_file)
                local core = require("core")
                core.job.spawn("microsoft-edge-stable", {
                    output_file,
                }, {}, function() end, function() end, function() end)
            end,
            -- whether to clean all pdf files on VimLeave
            clean_temp_pdf = false,
        })
    end,
}
