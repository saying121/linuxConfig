return {
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
            postfix = { enabled = true },
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
}
