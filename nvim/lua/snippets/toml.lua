---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

local crates = {
    ["mimalloc "] = "面向性能和安全的嵌入式分配器",
    ["juniper"] = "graphql 服务器库",
    ["GraphQL"] = "在终端中添加颜色的最简单方法",
    ["colored"] = "在终端中添加颜色的最简单方法",
    ["keyring"] = "用于管理密码/凭据的跨平台库",
    ["actix"] = "Rust 的 Actor 框架",
    ["atoi"] = "直接从安全代码中的 `[u8]` 切片解析整数",
    ["bitflags"] = "一个类型安全的位掩码标志生成器，对 **C** 风格标志集很有用。它可用于围绕 **C** api 创建符合人体工程学的包装器",
    ["byteorder"] = "这个 crate 提供了以大端或小端顺序编码和解码数字的便捷方法",
    ["cc"] = "**cargo** 构建脚本的构建时依赖项，以协助调用本机 **C** 编译器将本机 **C** 代码编译成静态存档，以便链接到 **Rust** 代码。",
    ["chrono"] = "**Rust** 的日期和时间库",
    ["flate2"] = "deflate 压缩和解压缩公开为 read/buf 读/写流。支持 miniz oxide 和多个 zlib 实现。支持 zlib、gzip 和原始 deflate 流。",
    ["lazy_static"] = "一个宏，用于在 **Rust** 中声明延迟计算的静态变量。（该库已经废弃，在 **Rust** 1.70.0 版本开始，用 `use std::{cell::OnceCell, sync::OnceLock};` 取代）",
    ["num_cpus"] = "获取机器上的 cpu 数量。",
    ["opentelementry"] = "*open telemetry* 提供一组 api、库、代理和收集器服务来从您的应用程序捕获分布式跟踪和指标。您可以使用 prometheus、jaeger 和其他可观察性工具来分析它们。",
    ["parking_lot"] = "标准同步原语的更紧凑和高效的实现",
    ["percent-encoding"] = "百分比编码和解码",
    ["plotters"] = "一个 **Rust** 绘图库，专注于 wasm 和本机应用程序的数据绘图",
    ["regex"] = "**Rust** 正则表达式的实现",
    ["same_file"] = "一个简单的crate，用于确定两个文件路径是否指向同一个文件。",
    ["thirtyfour"] = "thirfyfour 是一个用于 **Rust** 的 selenium / web 驱动程序库，用于自动化网站 ui 测试。它支持完整的 w3c 网络驱动规范。",
    ["thread_local"] = "每个线程对象本地存储",
    ["tower"] = "tower 是一个模块化和可重用组件库，用于构建强大的客户端和服务器。",
    ["tracing"] = "**Rust** 的应用程序级跟踪。 log",
    ["unicode-segmentation"] = "这个板条箱根据 Unicode 标准附件 #29 规则提供字素簇、单词和句子边界。",
}
local file = {
    ["dirs"] = "一个小型低级库，通过利用 Linux 上的 xdg 基本/用户目录规范（已知的文件夹 api）定义的机制，为 linux、windows、macos 和 redox 上的配置、缓存和其他数据提供特定于平台的标准目录位置在 Windows 上，以及在 Macos 上的标准目录指南。",
    ["glob"] = "支持根据 unix shell 样式模式匹配文件路径",
    ["memmap"] = "用于内存映射文件 io 的跨平台 **Rust** api",
    ["tar"] = "tar 文件读取器和写入器的 **Rust** 实现",
    ["walkdir"] = "递归地遍历一个目录。",
}
local img = {
    ["image"] = "用 **Rust** 编写的成像库。为最常见的图像格式提供基本的过滤器和解码器。",
    ["opencv"] = "opencv 的 **Rust** 绑定",
}
local performance = {
    ["criterion"] = "criterion.rs 通过快速准确地检测和测量性能改进或回归（即使是很小的改进）来帮助您编写快速代码。您可以自信地进行优化，了解每次更改如何影响代码的性能。",
    ["flame"] = "专为 **Rust** 打造的火焰图分析工具，可以告诉你程序在哪些代码上花费的时间过多，非常适合用于代码性能瓶颈的分析",
}
local encoding = {
    ["base64"] = "将 base64 编码和解码为字节或 utf8",
    ["dashmap"] = "用于 **Rust** 的超快并发哈希映射。",
    ["data-encoding"] = "高效且可自定义的数据编码函数，例如 base64、base32 和 hex",
    ["digest"] = "加密散列函数和消息认证码的特征",
    ["ring"] = "使用 **Rust** 的安全、快速、小型加密",
    ["serpent "] = "蛇块密码",
}
local math = {
    ["approx"] = "近似浮点相等比较和断言。",
    ["ndarray"] = "用于一般元素和数字的 n 维数组。轻量级数组视图和切片；视图支持分块和拆分。",
    ["num"] = "**Rust** 的数字类型和特征的集合，包括 *bigint*、*complex*、*rational*、范围迭代器、泛型整数等等！",
    ["num-complex"] = "**Rust** 的复数实现",
    ["rand"] = "该包提供了随机源",
    ["rand_distr"] = "从随机数分布中抽样",
}
local web_framework = {
    ["actix-web"] = "actix web 是一个强大、实用、速度极快的 **Rust** 网络框架",
    ["axum"] = "专注于人体工程学和模块化的网络框架",
    ["rocket"] = "专注于可用性、安全性、可扩展性和速度的 Web 框架。",
    ["salvo"] = "salvo 是一个强大而简单的 **Rust** Web 服务器框架。",
}
local channel = {
    ["async-channel"] = "异步多生产者多消费者通道(mpmc)",
    ["crossbeam"] = "并发编程的工具(mpmc)",
    ["flume"] = "一个极快的多生产者渠道(mpmc)",
}
local net = {
    ["openssl"] = "OpenSSL bindings",
    ["bytes"] = "处理字节的类型和特征",
    ["http"] = "一组用于表示 http 请求和响应的类型。",
    ["hyper"] = "快速正确的 **Rust** http 实现",
    ["ipgeolocate"] = "解析 ip 位置等信息",
    ["reqwest"] = "更高级别的 http 客户端库",
    ["robotstxt"] = "google 的 robots.txt 解析器和匹配器 C++ 库的本机 Rust 端口。",
    ["scraper"] = "**HTML** 解析 并使用 CSS 选择器查询",
    ["select"] = "一个从 **HTML** 文档中提取有用数据的库，适用于网络抓取。",
    ["socks5"] = "WIP",
    ["url"] = "**Rust** 的 **URL** 库，基于 WHATWG url 标准",
    ["warp"] = "以极快的速度提供网络服务",
}
local async = {
    ["async-trait"] = "异步特征方法的类型擦除",
    ["async-std"] = "**Rust** 标准库的异步版本",
    ["futures"] = "零分配、可组合和类似迭代器接口的 futures 和 streams 实现",
    ["mio"] = "轻量级非阻塞 I/O。",
    ["pin-utils"] = "用于固定的实用程序",
    ["tokio"] = "一个事件驱动的、非阻塞的 I/O 平台，用于编写异步 I/O 支持的应用程序",
    ["tokio-graceful-shutdown"] = "对基于 tokio 的服务执行正常关闭的实用程序。",
    ["tokio-stream"] = "使用 `stream` 和 `tokio` 的实用程序。",
    ["tokio-test"] = "基于 tokio 和 future 的代码的测试实用程序",
}
local database = {
    ["diesel"] = "用于 postgresql、sqlite 和 mysql 的安全、可扩展的 orm 和查询构建器",
    ["metrics"] = "对数据库连接性能测试",
    ["mysql"] = "用 **Rust** 实现的 mysql 客户端库",
    ["mysql_async"] = "基于 tokio 的异步 mysql 客户端库。",
    ["postgres"] = "一个本地的、同步的 postgresql 客户端",
    ["rbatis"] = "**Rust** sql 工具包和 orm 库。一个异步的、纯 **Rust** 的 sql crate，具有编译时动态 sql",
    ["redis_rs"] = "简单的redis客户端库",
    ["rusqlite"] = "符合人体工程学的 sqlite 包装器",
    ["sqlx"] = "**Rust** SQL 工具包。一个异步的、纯 **Rust** 的 sql crate，具有编译时检查查询而没有 dsl。支持 postgresql、mysql 和 sqlite。",
}
local serde = {
    ["csv"] = "支持 serde 的快速 csv 解析。",
    ["jsonpath"] = "Rust 的 jsonpath",
    ["serde"] = "一个通用的序列化/反序列化框架",
    ["serde_json"] = "一种 json 序列化文件格式",
    ["serde_yaml"] = "serde 的 yaml 数据格式",
    ["toml"] = "toml 格式文件和流的本机 **Rust** 编码器和解码器。为 toml 数据提供标准序列化/反序列化特征的实现，以促进反序列化和序列化 **Rust** 结构。",
}
local error = {
    ["anyhow"] = "灵活的具体错误类型建立在 std::error::error 之上",
    ["thiserror"] = "推导（错误）",
}
local terminal = {
    ["ansi_term"] = "ansi 终端颜色和样式库（粗体、下划线）",
    ["clap"] = "一个简单易用、高效且功能齐全的命令行参数解析器",
    ["crossterm"] = "用于操作终端的跨平台终端库。",
    ["cursive"] = "一个专注于易用性的 tui（文本用户界面）库。",
    ["tui"] = "用于构建丰富的终端用户界面或仪表板的库",
}
local gui = {
    ["dioxus"] = "dioxus 可以轻松快速地使用 **Rust** 构建复杂的用户界面。任何 dioxus 应用程序都可以在 **Web** 浏览器中作为桌面应用程序、移动应用程序或任何其他地方运行，前提是您构建了正确的渲染器。",
    ["slint"] = "gui 工具包，可有效地为嵌入式设备和桌面应用程序开发流畅的图形用户界面",
    ["wayland-client"] = "绑定到 Wayland 协议的标准 c 实现，客户端",
    ["x11rb"] = "**Rust** 绑定到 X11",
}

local all = vim.tbl_deep_extend(
    "force",
    async,
    channel,
    crates,
    database,
    encoding,
    error,
    file,
    gui,
    img,
    math,
    net,
    performance,
    serde,
    terminal,
    web_framework
)

local snippets = {
    s(
        {
            trig = "release",
            priority = 30000,
            dscr = "发布配置",
        },
        fmt(
            [[
[profile.release]
opt-level = 3
lto = true

        ]],
            {}
        )
    ),
}

for name, describe in pairs(all) do
    table.insert(
        snippets,
        s(
            {
                trig = name,
                priority = 30000,
                dscr = describe,
            },
            fmt(name .. [[ = { version = "<>" }]], {
                i(1, ""),
            }, { delimiters = "<>" })
        )
    )
end

return snippets
