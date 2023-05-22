local postfix = {
    ["Arc::new"] = {
        body = "Arc::new(${receiver})",
        description = "Put the expression into an `Arc`",
        postfix = "arc",
        requires = "std::sync::Arc",
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
    ["Rc::new"] = {
        body = "Rc::new(${receiver})",
        description = "Put the expression into an `Rc`",
        postfix = "rc",
        requires = "std::rc::Rc",
        scope = "expr",
    },
    Some = {
        body = "Some(${receiver})",
        description = "Wrap the expression in an `Option::Some`",
        postfix = "some",
        scope = "expr",
    },
    eprln = {
        body = "eprintln!({$1}, ${receiver});$0",
        description = "Wrap the expression in an `eprintln!`",
        postfix = "eprln",
        scope = "expr",
    },
    prln = {
        body = "println!({${1::?}}, ${receiver});$0",
        description = "Wrap the expression in an `eprintln!`",
        postfix = "prln",
        scope = "expr",
    },
}

local prefix = {
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
    -- letv = {
    --     prefix = { "letv" },
    --     body = {
    --         "let ${1:var} = $2;$0",
    --     },
    --     description = "let … = …;",
    --     scope = "expr",
    -- },
    letm = {
        prefix = { "letm" },
        body = {
            "let mut ${1:var} = $2;$0",
        },
        description = "let mut … = …;",
        scope = "expr",
    },
}

local friendly = {
    Err = {
        body = { "Err(${1})" },
        description = "Err(…)",
        prefix = "Err",
    },
    Ok = {
        body = { "Ok(${1:result})" },
        description = "Ok(…)",
        prefix = "Ok",
    },
    Some = {
        body = { "Some(${1})" },
        description = "Some(…)",
        prefix = "Some",
    },
    allow = {
        body = { "#![allow(${1})]" },
        description = "#![allow(…)]",
        prefix = "allow",
    },
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
    cfg = {
        body = { "#[cfg(${1})]" },
        description = "#[cfg(…)]",
        prefix = "cfg",
    },
    ["cfg!"] = {
        body = { "cfg!(${1})" },
        description = "cfg!(…)",
        prefix = "cfg!",
    },
    cfg_attr = {
        body = { "#[cfg_attr(${1}, ${2})]" },
        description = "#[cfg_attr(…, …)]",
        prefix = "cfg_attr",
    },
    column = {
        body = { "column!()" },
        description = "column!()",
        prefix = "column",
    },
    concat = {
        body = { "concat!(${1})" },
        description = "concat!(…)",
        prefix = "concat",
    },
    concat_idents = {
        body = { "concat_idents!(${1})" },
        description = "concat_idents!(…)",
        prefix = "concat_idents",
    },
    const = {
        body = { "const ${1:CONST}: ${2:Type} = ${4:init};" },
        description = "const …: … = …;",
        prefix = "const",
    },
    debug_assert = {
        body = { "debug_assert!(${1});" },
        description = "debug_assert!(…)",
        prefix = "debug_assert",
    },
    debug_assert_eq = {
        body = { "debug_assert_eq!(${1}, ${2});" },
        description = "debug_assert_eq!(…, …)",
        prefix = "debug_assert_eq",
    },
    deny = {
        body = { "#![deny(${1})]" },
        description = "#![deny(…)]",
        prefix = "deny",
    },
    derive = {
        body = { "#[derive(${1})]" },
        description = "#[derive(…)]",
        prefix = "derive",
    },
    -- else = {
    --   body = { "else {", "    ${1:unimplemented!();}", "}" },
    --   description = "else { … }",
    --   prefix = "else"
    -- },
    enum = {
        body = { "#[derive(Debug)]", "enum ${1:Name} {", "    ${2:Variant1},", "    ${3:Variant2},", "}" },
        description = "enum … { … }",
        prefix = "enum",
    },
    env = {
        body = { 'env!("${1}")' },
        description = 'env!("…")',
        prefix = "env",
    },
    ["extern-crate"] = {
        body = { "extern crate ${1:name};" },
        description = "extern crate …;",
        prefix = "extern-crate",
    },
    ["extern-fn"] = {
        body = { 'extern "C" fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {', "    ${5:// add code here}", "}" },
        description = 'extern "C" fn …(…) { … }',
        prefix = "extern-fn",
    },
    ["extern-mod"] = {
        body = { 'extern "C" {', "    ${2:// add code here}", "}" },
        description = 'extern "C" { … }',
        prefix = "extern-mod",
    },
    feature = {
        body = { "#![feature(${1})]" },
        description = "#![feature(…)]",
        prefix = "feature",
    },
    file = {
        body = { "file!()" },
        description = "file!()",
        prefix = "file",
    },
    fn = {
        body = { "fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {", "    ${5:unimplemented!();}", "}" },
        description = "fn …(…) { … }",
        prefix = "fn",
    },
    -- for = {
    --   body = { "for ${1:pat} in ${2:expr} {", "    ${3:unimplemented!();}", "}" },
    --   description = "for … in … { … }",
    --   prefix = "for"
    -- },
    format = {
        body = { 'format!("${1}")' },
        description = "format!(…)",
        prefix = "format",
    },
    format_args = {
        body = { 'format_args!("${1}")' },
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
    impl = {
        body = { "impl ${1:Type} {", "    ${2:// add code here}", "}" },
        description = "impl … { … }",
        prefix = "impl",
    },
    ["impl-trait"] = {
        body = { "impl ${1:Trait} for ${2:Type} {", "    ${3:// add code here}", "}" },
        description = "impl … for … { … }",
        prefix = "impl-trait",
    },
    include = {
        body = { 'include!("${1}");' },
        description = 'include!("…");',
        prefix = "include",
    },
    include_bytes = {
        body = { 'include_bytes!("${1}")' },
        description = 'include_bytes!("…")',
        prefix = "include_bytes",
    },
    include_str = {
        body = { 'include_str!("${1}")' },
        description = 'include_str!("…")',
        prefix = "include_str",
    },
    ["inline-fn"] = {
        body = { "#[inline]", "pub fn ${1:name}() {", "    ${2:unimplemented!();}", "}" },
        description = "inlined function",
        prefix = "inline-fn",
    },
    let = {
        body = { "let ${1:pat} = ${2:expr};" },
        description = "let … = …;",
        prefix = "let",
    },
    line = {
        body = { "line!()" },
        description = "line!()",
        prefix = "line",
    },
    loop = {
        body = { "loop {", "    ${2:unimplemented!();}", "}" },
        description = "loop { … }",
        prefix = "loop",
    },
    macro_rules = {
        body = { "macro_rules! ${1:name} {", "    (${2}) => (${3})", "}" },
        description = "macro_rules! … { … }",
        prefix = "macro_rules",
    },
    macro_use = {
        body = { "#[macro_use(${1})]" },
        description = "#[macro_use(…)]",
        prefix = "macro_use",
    },
    main = {
        body = { "fn main() {", "    ${1:unimplemented!();}", "}" },
        description = "fn main() { … }",
        prefix = "main",
    },
    match = {
        body = { "match ${1:expr} {", "    ${2:Some(expr)} => ${3:expr},", "    ${4:None} => ${5:expr},", "}" },
        description = "match … { … }",
        prefix = "match",
    },
    mod = {
        body = { "mod ${1:name};" },
        description = "mod …;",
        prefix = "mod",
    },
    ["mod-block"] = {
        body = { "mod ${1:name} {", "    ${2:// add code here}", "}" },
        description = "mod … { … }",
        prefix = "mod-block",
    },
    module_path = {
        body = { "module_path!()" },
        description = "module_path!()",
        prefix = "module_path",
    },
    no_core = {
        body = { "#![no_core]" },
        description = "#![no_core]",
        prefix = "no_core",
    },
    no_std = {
        body = { "#![no_std]" },
        description = "#![no_std]",
        prefix = "no_std",
    },
    option_env = {
        body = { 'option_env!("${1}")' },
        description = 'option_env!("…")',
        prefix = "option_env",
    },
    panic = {
        body = { 'panic!("${1}");' },
        description = "panic!(…);",
        prefix = "panic",
    },
    print = {
        body = { 'print!("${1}");' },
        description = "print!(…);",
        prefix = "print",
    },
    println = {
        body = { 'println!("${1}");' },
        description = "println!(…);",
        prefix = "println",
    },
    repr = {
        body = { "#[repr(${1})]" },
        description = "#[repr(…)]",
        prefix = "repr",
    },
    static = {
        body = { "static ${1:STATIC}: ${2:Type} = ${4:init};" },
        description = "static …: … = …;",
        prefix = "static",
    },
    stringify = {
        body = { "stringify!(${1})" },
        description = "stringify!(…)",
        prefix = "stringify",
    },
    struct = {
        body = { "#[derive(Debug)]", "struct ${1:Name} {", "    ${2:field}: ${3:Type}", "}" },
        description = "struct … { … }",
        prefix = "struct",
    },
    ["struct-tuple"] = {
        body = { "struct ${1:Name}(${2:Type});" },
        description = "struct …(…);",
        prefix = "struct-tuple",
    },
    ["struct-unit"] = {
        body = { "struct ${1:Name};" },
        description = "struct …;",
        prefix = "struct-unit",
    },
    -- test = {
    --   body = { "#[test]", "fn ${1:name}() {", "    ${2:unimplemented!();}", "}" },
    --   description = "#[test]",
    --   prefix = "test"
    -- },
    thread_local = {
        body = { "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});" },
        description = "thread_local!(static …: … = …);",
        prefix = "thread_local",
    },
    trait = {
        body = { "trait ${1:Name} {", "    ${2:// add code here}", "}", "" },
        description = "trait … { … }",
        prefix = "trait",
    },
    try = {
        body = { "try!(${1})" },
        description = "try!(…)",
        prefix = "try",
    },
    type = {
        body = { "type ${1:Alias} = ${2:Type};" },
        description = "type … = …;",
        prefix = "type",
    },
    unimplemented = {
        body = { "unimplemented!()" },
        description = "unimplemented!()",
        prefix = "unimplemented",
    },
    unreachable = {
        body = { "unreachable!(${1})" },
        description = "unreachable!(…)",
        prefix = "unreachable",
    },
    vec = {
        body = { "vec![${1}]" },
        description = "vec![…]",
        prefix = "vec",
    },
    warn = {
        body = { "#![warn(${1})]" },
        description = "#![warn(…)]",
        prefix = "warn",
    },
    -- while = {
    --   body = { "while ${1:condition} {", "    ${2:unimplemented!();}", "}" },
    --   description = "while … { … }",
    --   prefix = "while"
    -- },
    ["while-let"] = {
        body = { "while let ${1:Some(pat)} = ${2:expr} {", "    ${0:unimplemented!();}", "}" },
        description = "while let … = … { … }",
        prefix = "while-let",
    },
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

local custom = vim.tbl_deep_extend("force", postfix, prefix, friendly)

return {
    ["rust-analyzer"] = {
        completion = {
            snippets = {
                custom = custom,
            },
        },
    },
}
