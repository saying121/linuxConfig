local postfix = {
    ["Arc::new"] = {
        body = "Arc::new(${receiver})",
        description = "Put the expression into an `Arc`",
        postfix = "arc",
        requires = "std::sync::Arc",
        scope = "expr",
    },
    ["Arc::clone"] = {
        body = "Arc::clone(&${receiver})",
        description = "Put the expression into an `Arc::clone`",
        postfix = "arc_clone",
        requires = "std::sync::Arc",
        scope = "expr",
    },
    ["Rc::new"] = {
        body = "Rc::new(${receiver})",
        description = "Put the expression into an `Rc`",
        postfix = "rc",
        requires = "std::rc::Rc",
        scope = "expr",
    },
    ["Rc::clone"] = {
        body = "Rc::clone(${receiver})",
        description = "Put the expression into an `Rc::clone`",
        postfix = "rc_clone",
        requires = "std::rc::Rc",
        scope = "expr",
    },
    ["Box::pin"] = {
        body = "Box::pin(${receiver})",
        description = "Put the expression into a pinned `Box`",
        postfix = "pinbox",
        requires = "std::boxed::Box",
        scope = "expr",
    },
    Err = {
        body = "Err(${receiver})",
        description = "Wrap the expression in a `Result::Err`",
        postfix = "err",
        scope = "expr",
    },
    Ok = {
        body = "Ok(${receiver})",
        description = "Wrap the expression in a `Result::Ok`",
        postfix = "ok",
        scope = "expr",
    },
    Some = {
        body = "Some(${receiver})",
        description = "Wrap the expression in an `Option::Some`",
        postfix = "some",
        scope = "expr",
    },
    eprln = {
        body = 'eprintln!("{$1}", ${receiver});$0',
        description = "Wrap the expression in an `eprintln!`",
        postfix = "eprln",
        scope = "expr",
    },
    prln = {
        body = 'println!("{${1::#?}}", ${receiver});$0',
        description = "Wrap the expression in an `println!`",
        postfix = "prln",
        scope = "expr",
    },
    prvar = {
        body = 'println!(r##"(| ${receiver} |) ${2:->} {${1::#?}}"##, ${receiver});$0',
        description = "Wrap the expression in an `println!`",
        postfix = "prvar",
        scope = "expr",
    },
    dbg_d = {
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!(${receiver});$0",
        },
        description = "Wrap the expression in an `println!`",
        postfix = "dbg_d",
        scope = "expr",
    },
    dbgr_d = {
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!(&${receiver});$0",
        },
        description = "Wrap the expression in an `println!`",
        postfix = "dbgr_d",
        scope = "expr",
    },
    Br = {
        body = {
            "{$1",
            "    ${receiver}",
            "$0}",
        },
        description = "Wrap the expression in an `println!`",
        postfix = "Br",
        scope = "expr",
    },
}

local prefix = {
    async = {
        prefix = { "async" },
        body = {
            "async $0",
        },
        description = "Insert a async call",
        scope = "expr",
    },
    unsafe = {
        prefix = { "unsafe" },
        body = {
            "unsafe {",
            "\t$1",
            "}$0",
        },
        description = "Insert a unsafe call",
        scope = "expr",
    },
    thread_spawn = {
        prefix = { "spawn", "tspawn" },
        body = {
            "thread::spawn(move || {",
            "\t$1",
            "});$0",
        },
        description = "Insert a thread::spawn call",
        requires = "std::thread",
        scope = "expr",
    },
    thread_sleep = {
        prefix = { "sleep", "tsleep" },
        body = {
            "thread::sleep($1);$0",
        },
        description = "Insert a thread::sleep",
        requires = "std::thread",
        scope = "expr",
    },
    tokio_spawn = {
        prefix = { "tkspawn" },
        body = {
            "tokio::spawn(async move {",
            "\t$1",
            "});$0",
        },
        description = "Insert a tokio::spawn call",
        requires = "tokio",
        scope = "expr",
    },
    letm = {
        prefix = { "letm" },
        body = {
            "let mut ${1:var} = $2;$0",
        },
        description = "let mut … = …;",
        scope = "expr",
    },
    ["return"] = {
        prefix = { "rt", "return" },
        body = {
            "return $1;",
        },
        description = "return …;",
        scope = "expr",
    },
    ["tracing"] = {
        prefix = { "tracing_subscriber", "log_sub" },
        body = {
            "tracing_subscriber::fmt()",
            ".with_max_level(tracing::Level::DEBUG)",
            ".with_test_writer()",
            ".init();",
        },
        requires = { "tracing_subscriber", "tracing" },
        description = "subscriber debug",
        scope = "expr",
    },
    ["tracing_appender"] = {
        prefix = { "tracing_appender", "log_sub" },
        body = {
            [[let appender = rolling::never("some/path", "xxx.log");]],
            "let (non_blocking, _guard) = tracing_appender::non_blocking(appender);",
            "",
            [[let env_filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));]],
            "",
            "let file_layer = fmt::layer() .with_thread_ids(true) .with_level(true) .with_ansi(false) .with_writer(non_blocking);",
            "",
            "let formatting_layer = fmt::layer() .pretty() .with_writer(std::io::stderr);",
            "",
            "Registry::default() .with(env_filter) .with(formatting_layer) .with(file_layer) .init();",
        },
        requires = {
            "tracing_appender::rolling",
            "tracing_subscriber::fmt",
            "tracing_subscriber::prelude::__tracing_subscriber_SubscriberExt",
            "tracing_subscriber::util::SubscriberInitExt",
            "tracing_subscriber::EnvFilter",
            "tracing_subscriber::Registry",
        },
        description = "subscriber debug",
        scope = "expr",
    },
}

local ratatui = {
    t_start = {
        prefix = { "tui_setup" },
        body = {
            "// setup terminal",
            -- "fn setup_terminal() -> Result<Terminal<CrosstermBackend<Stdout>>> {",
            [[let mut stdout = io::stdout();]],
            [[enable_raw_mode()?;]],
            [[execute!(stdout, EnterAlternateScreen)?;]],
            [[let backend = CrosstermBackend::new(stdout);]],
            [[let mut terminal = Terminal::new(backend)?;]],
            -- "}",
        },
        description = "terminal start flow",
        requires = {
            "std::io",
            -- "std::io::Stdout",
            "crossterm::terminal::enable_raw_mode",
            "crossterm::terminal::EnterAlternateScreen",
            "crossterm::event::EnableMouseCapture",
            -- -- "crossterm::execute", -- rust-analyzer 解析不出来宏
            "ratatui::prelude::CrosstermBackend",
            "ratatui::Terminal",
        },
        scope = "expr",
    },
    t_end = {
        prefix = { "tui_restore" },
        body = {
            "// restore terminal",
            "disable_raw_mode()?;",
            [[
execute!(
    terminal.backend_mut(),
    LeaveAlternateScreen,
    DisableMouseCapture
)?;
            ]],
            "terminal.show_cursor()?;",
        },
        description = "terminal end flow",
        requires = {
            "crossterm::event::DisableMouseCapture",
            -- "crossterm::execute", -- rust-analyzer 解析不出来宏
            "crossterm::terminal::LeaveAlternateScreen",
            "crossterm::terminal::disable_raw_mode",
        },
        scope = "expr",
    },
}

local friendly = {
    assert = {
        body = { "assert!(${1});" },
        description = "assert!(…);",
        prefix = "assert",
    },
    assert_eq = {
        body = { "assert_eq!(${1}, ${2});" },
        description = "assert_eq!(…, …);",
        prefix = "assert_eq",
    },
    debug_assert_eq = {
        body = { "debug_assert_eq!(${1}, ${2});" },
        description = "debug_assert_eq!(…, …)",
        prefix = "debug_assert_eq",
    },
    debug_assert_ne = {
        body = { "debug_assert_ne!(${1}, ${2});" },
        description = "debug_assert_ne!(…, …)",
        prefix = "debug_assert_ne",
    },
    bench = {
        body = {
            "#[bench]",
            "fn ${1:name}(b: &mut test::Bencher) {",
            "    ${2:b.iter(|| ${3:/* benchmark code */})}",
            "}",
        },
        description = "#[bench]",
        prefix = "bench",
    },
    concat_idents = {
        body = { "concat_idents!(${1})" },
        description = "concat_idents!(…)",
        prefix = "concat_idents",
    },
    -- fn_r = {
    --     body = { "fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {", "    ${5:unimplemented!();}", "}" },
    --     description = "fn …(…) { … }",
    --     prefix = "fnr",
    -- },
    -- fn = {
    --     body = { "fn ${1:name}(${2:arg}: ${3:Type}) {", "    ${5:unimplemented!();}", "}" },
    --     description = "fn …(…) { … }",
    --     prefix = "fn",
    -- },
    format = {
        body = { 'format!("${1}"${2})' },
        description = "format!(…)",
        prefix = "format",
    },
    format_args = {
        body = { 'format_args!("${1}"${2})' },
        description = "format_args!(…)",
        prefix = "format_args",
    },
    -- if = {
    --   body = { "if ${1:condition} {", "    ${2:unimplemented!();}", "}" },
    --   description = "if … { … }",
    --   prefix = "if"
    -- },
    -- ["if-let"] = {
    --     body = { "if let ${1:Some(pat)} = ${2:expr} {", "    ${0:unimplemented!();}", "}" },
    --     description = "if let … = … { … }",
    --     prefix = "if-let",
    -- },
    ["inline-fn"] = {
        body = { "#[inline]", "pub fn ${1:name}() {", "    ${2:unimplemented!();}", "}" },
        description = "inlined function",
        prefix = "inline-fn",
    },
    let = {
        body = { "let ${1:pat} = ${2:expr};" },
        description = "let … = …;",
        prefix = "letv",
    },
    -- macro_rules = {
    --     body = { "macro_rules! ${1:name} {", "    (${2}) => (${3})", "}" },
    --     description = "macro_rules! … { … }",
    --     prefix = "macro_rules",
    -- },
    macro_use = {
        body = { "#[macro_use(${1})]" },
        description = "#[macro_use(…)]",
        prefix = "macro_use",
    },
    -- main = {
    --     body = { "fn main() {", "    ${1:unimplemented!();}", "}" },
    --     description = "fn main() { … }",
    --     prefix = "main",
    -- },
    match_opt = {
        body = {
            "match ${1:expr} {",
            "    Some(${2:expr}) => ${3:expr},",
            "    ${4:None} => ${5:expr},",
            "}",
        },
        description = "match … { … }",
        prefix = "match_option",
    },
    match_res = {
        body = {
            "match ${1:expr} {",
            "    Ok(${2:expr}) => ${3:expr},",
            "    Err(${4:err}) => ${5:expr},",
            "}",
        },
        description = "match … { … }",
        prefix = "match_res",
    },
    option_env = {
        body = { 'option_env!("${1}")' },
        description = 'option_env!("…")',
        prefix = "option_env",
    },
    panic = {
        body = { 'panic!("${1}"${2});' },
        description = "panic!(…);",
        prefix = "panic",
    },
    print = {
        body = { 'print!("$1"$2);$0' },
        description = "print!(…);",
        prefix = "print",
    },
    println = {
        body = { 'println!("$1"$2);$0' },
        description = "println!(…);",
        prefix = "println",
    },
    -- repr = {
    --     body = { "#[repr(${1})]" },
    --     description = "#[repr(…)]",
    --     prefix = "repr",
    -- },
    -- static = {
    --     body = { "static ${1:STATIC}: ${2:Type} = ${4:init};" },
    --     description = "static …: … = …;",
    --     prefix = "static",
    -- },
    thread_local = {
        body = { "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});" },
        description = "thread_local!(static …: … = …);",
        prefix = "thread_local",
    },
    try = {
        body = { "try!(${1})" },
        description = "try!(…)",
        prefix = "try",
    },
    -- ["while-let"] = {
    --     body = { "while let ${1:Some(pat)} = ${2:expr} {", "    ${0:unimplemented!();}", "}" },
    --     description = "while let … = … { … }",
    --     prefix = "while-let",
    -- },
    write = {
        body = { 'write!(${1}, "${2}")' },
        description = "write!(…)",
        prefix = "write",
    },
    writeln = {
        body = { 'writeln!(${1}, "${2}")' },
        description = "writeln!(…, …)",
        prefix = "writeln",
    },
}

return vim.tbl_deep_extend("force", postfix, prefix, friendly, ratatui)
