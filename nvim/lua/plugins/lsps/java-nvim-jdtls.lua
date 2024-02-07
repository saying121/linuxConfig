return {
    "mfussenegger/nvim-jdtls",
    dependencies = { "williamboman/mason.nvim" },
    event = {
        "UIEnter *.java",
        "BufNew *.java",
    },
    config = function()
        -- local home = vim.env.HOME
        local cache = vim.fn.stdpath("cache")

        local WORKSPACE_PATH = cache .. "/jdtls_workspace/"
        local OS
        if vim.fn.has("mac") == 1 then
            OS = "mac"
        elseif vim.fn.has("unix") == 1 then
            OS = "linux"
        else
            vim.notify("Unsupported system")
            return
        end

        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        -- local install_path = "/usr/share/java/jdtls"
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

        -- root directory
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        -- workspace dir
        local project_name = root_dir or vim.fn.getcwd()
        local workspace_dir = WORKSPACE_PATH .. project_name
        local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local capabilities = require("public.lsp_attach").capabilities
        capabilities = vim.list_extend(capabilities, {
            workspace = { configuration = true },
            textDocument = {
                completion = {
                    completionItem = { snippetSupport = true },
                },
            },
        })

        -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
        local config = {
            -- stylua: ignore
            cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                "-configuration", install_path .. "/config_" .. OS,
                "-data", workspace_dir,
            },
            root_dir = root_dir,
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request

            -- workspaceFolders = { "file:://" .. vim.env.HOME .. "/Project" },
            settings = {
                java = {
                    eclipse = { downloadSources = true },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                        maven = { userSettings = nil },
                        runtimes = {
                            {
                                name = "JavaSE-1.8",
                                path = "/usr/lib/jvm/java-8-openjdk/",
                            },
                            {
                                name = "JavaSE-11",
                                path = "/usr/lib/jvm/java-11-openjdk/",
                            },
                            {
                                name = "JavaSE-17",
                                path = "/usr/lib/jvm/java-17-openjdk/",
                            },
                            {
                                name = "JavaSE-21",
                                path = "/usr/lib/jvm/java-21-openjdk/",
                            },
                        },
                    },
                    trace = { server = "verbose" },
                    import = {
                        gradle = { enabled = true },
                        maven = { enabled = true },
                        exclusions = {
                            "**/node_modules/**",
                            "**/.metadata/**",
                            "**/archetype-resoutces/**",
                            "**/META-INF/maven/**",
                            "**/**/test/**",
                        },
                    },
                    referencesCodeLens = { enabled = true },
                    signatureHelp = { enabled = true },
                    implementationsCodeLens = { enabled = true },
                    format = {
                        enabled = true,
                        -- settings = {
                        --     url = "/home/jrakhman/.config/nvim/lua/user/formatter/eclipse-java-custom-style.xml",
                        --     profile = "GoogleStyle",
                        -- },
                    },
                    saveActions = { organizeImports = nil },
                    contentProvider = { preferred = "fernflower" },
                    autobuild = { enabled = true },
                    completion = {
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                            "org.junit.Assert.*",
                            "org.junit.Assume.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "org.junit.jupiter.api.Assumptions.*",
                            "org.junit.jupiter.api.DynamicContainer.*",
                            "org.junit.jupiter.api.DynamicTest.*",
                        },
                    },
                    maven = { downloadSources = true },
                    references = { includeDecompiledSources = false },
                    inlayHints = {
                        parameterNames = {
                            enabled = "all", -- literals, all, none
                        },
                    },
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
                        -- hashCodeEquals = { useJava7Objects = treu },
                        useBlocks = true,
                    },
                },
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
                extendedClientCapabilities = extendedClientCapabilities,
            },
            filetypes = { "java" },
            single_file_support = true,
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                require("jdtls").setup_dap()
                require("public.lsp_attach").on_attach(client, bufnr)

                local opts, keymap = { noremap = true, silent = true, buffer = bufnr }, vim.keymap.set

                keymap("n", "<space>f", function()
                    vim.lsp.buf.format({
                        async = true,
                        bufnr = bufnr,
                    })
                end, opts)

                -- keymap("n", "<leader>di", require("jdtls").organize_imports, opts)
                keymap("n", "<leader>dt", require("jdtls").test_class, opts)
                keymap("n", "<leader>dn", require("jdtls").test_nearest_method, opts)

                keymap("x", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
                keymap("n", "<leader>de", require("jdtls").extract_variable, opts)
                -- keymap("x", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

                keymap("x", "<leader>cxc", [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], opts)
                keymap("x", "<leader>cxv", [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]], opts)

                keymap("n", "gS", require("jdtls.tests").goto_subjects, opts)
                -- keymap("n", 'gs', require("jdtls.tests").super_implementation, opts)

                keymap("n", "<leader>tt", require("jdtls.dap").test_class, opts)
                keymap("n", "<leader>tr", require("jdtls.dap").test_nearest_method, opts)
                keymap("n", "<leader>tT", require("jdtls.dap").pick_test, opts)
            end,
        }
        -- This starts a new client & server,
        -- or attaches to an existing client & server depending on the `root_dir`.
        require("jdtls").start_or_attach(config)
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end,
}
