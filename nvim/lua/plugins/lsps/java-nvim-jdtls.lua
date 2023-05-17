return {
    "mfussenegger/nvim-jdtls",
    event = {
        "UIEnter *.java",
        "BufNew *.java",
    },
    config = function()
        local home = os.getenv("HOME")

        if vim.fn.has("mac") == 1 then
            WORKSPACE_PATH = home .. "/.config/jdtls_workspace/"
            OS = "mac"
        elseif vim.fn.has("unix") == 1 then
            WORKSPACE_PATH = home .. "/.config/jdtls_workspace/"
            OS = "linux"
        else
            vim.notify("Unsupported system")
            return
        end

        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()
        local java_debug_adapter_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
        local bundles = {}

        -- add java test & debugger into the bundles
        vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))
        vim.list_extend(
            bundles,
            vim.split(
                vim.fn.glob(java_debug_adapter_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
                "\n"
            )
        )

        -- calculate root directory
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        -- calculate workspace dir
        -- local util = require("public.utils")
        -- local project_name = vim.fn.fnamemodify(util.get_git_root_dir(vim.fn.getcwd(), "/.git"), ":p:h:t")
        local project_name = root_dir or vim.fn.getcwd()
        local workspace_dir = WORKSPACE_PATH .. project_name
        local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
        local config = {
            -- The command that starts the language server
            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
            cmd = {
                -- 💀
                "java", -- or '/path/to/java17_or_newer/bin/java'
                -- depends on if `java` is in your $PATH env variable and if it points to the right version.
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                -- 💀
                "-jar",
                vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                -- os.getenv('HOME').."/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar",
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
                -- Must point to the                                                     Change this to
                -- eclipse.jdt.ls installation                                           the actual version

                -- 💀
                "-configuration",
                install_path .. "/config_" .. OS,
                -- "/path/to/jdtls_install_location/config_SYSTEM",
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                -- Must point to the                      Change to one of `linux`, `win` or `mac`
                -- eclipse.jdt.ls installation            Depending on your system.

                -- 💀
                -- See `data directory configuration` section in the README
                "-data",
                workspace_dir,
                -- "/path/to/unique/per/project/workspace/folder",
            },

            -- 💀
            -- This is the default if not provided, you can remove it. Or adjust as needed.
            -- One dedicated LSP server & client will be started per unique root_dir
            root_dir = root_dir,

            -- Here you can configure eclipse.jdt.ls specific settings
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- for a list of options
            settings = {
                java = {
                    eclipse = {
                        downloadSources = true,
                    },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                        -- runtimes = {
                        --     {
                        --         name = "JavaSE-17",
                        --         path = "/home/jrakhman/.sdkman/candidates/java/17.0.4-oracle",
                        --     },
                        --     {
                        --         name = "JavaSE-11",
                        --         path = "/home/jrakhman/.sdkman/candidates/java/11.0.2-open",
                        --     },
                        -- },
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = false,
                    },
                    references = {
                        includeDecompiledSources = false,
                    },
                    inlayHints = {
                        parameterNames = {
                            enabled = "all", -- literals, all, none
                        },
                    },
                    format = {
                        enabled = true,
                        -- settings = {
                        --     url = "/home/jrakhman/.config/nvim/lua/user/formatter/eclipse-java-custom-style.xml",
                        --     profile = "GoogleStyle",
                        -- },
                    },
                },
                signatureHelp = { enabled = true },
                completion = {
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*",
                    },
                },
                contentProvider = { preferred = "fernflower" },
                extendedClientCapabilities = extendedClientCapabilities,
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    },
                    useBlocks = true,
                },
            },
            signatureHelp = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
            },
            contentProvider = { preferred = "fernflower" },
            extendedClientCapabilities = extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
            },
            flags = {
                allow_incremental_sync = true,
            },

            -- Language server `initializationOptions`
            -- You need to extend the `bundles` with paths to jar files
            -- if you want to use additional eclipse.jdt.ls plugins.
            --
            -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
            --
            -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
            init_options = {
                bundles = bundles,
            },
            filetypes = { "java" },
            single_file_support = true,
            on_attach = function(client, bufnr)
                require("jdtls").setup_dap()
                require("public.lsp_attach").on_attach(client, bufnr)

                local opts, keymap = { noremap = true, silent = true, buffer = bufnr }, vim.keymap.set

                keymap("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
                keymap("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
                keymap("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
                keymap("x", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
                keymap("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
                keymap("x", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

                keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
            end,
        }
        -- This starts a new client & server,
        -- or attaches to an existing client & server depending on the `root_dir`.
        require("jdtls").start_or_attach(config)
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end,
}
