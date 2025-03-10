---@type LazySpec
return {
    "stevearc/overseer.nvim",
    cmd = {
        "OverseerRun",
    },
    ---@type overseer.Config
    opts = {
        dap = false,
        strategy = {
            "toggleterm",
            direction = "float",
        },
    },
    ---@param opts overseer.Config
    config = function(self, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        ---@type overseer.TemplateDefinition|overseer.TemplateFileDefinition
        local template = {
            name = "Rust Release",
            builder = function(params)
                local wd = vim.fs.find("Cargo.toml", { upward = true, type = "file" })[1]

                local cwd = vim.fs.dirname(wd)
                ---@type overseer.TaskDefinition
                return {
                    cmd = { "cargo" },
                    args = { "build", "--release" },
                    name = "Greet",
                    -- set the working directory for the task
                    cwd = cwd,
                    -- additional environment variables
                    env = {
                        -- VAR = "FOO",
                    },
                    -- the list of components or component aliases to add to the task
                    -- components = { "my_custom_component", "default" },
                    -- arbitrary table of data for your own personal use
                    metadata = {
                        foo = "bar",
                    },
                }
            end,
            -- Optional fields
            -- desc = "",
            -- Tags can be used in overseer.run_template()
            tags = { overseer.TAG.BUILD },
            params = {
                -- See :help overseer-params
            },
            -- Determines sort order when choosing tasks. Lower comes first.
            priority = 50,
            -- Add requirements for this template. If they are not met, the template will not be visible.
            -- All fields are optional.
            condition = {
                -- A string or list of strings
                -- Only matches when current buffer is one of the listed filetypes
                filetype = { "rust" },
                -- A string or list of strings
                -- Only matches when cwd is inside one of the listed dirs
                -- dir = "/home/user/my_project",
                -- Arbitrary logic for determining if task is available
                callback = function(search)
                    -- print(vim.inspect(search))
                    return true
                end,
            },
        }

        overseer.register_template(template)
    end,
}
