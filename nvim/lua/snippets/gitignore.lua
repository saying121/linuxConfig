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

local mis = [[
### Miscellaneous
*.log
logs/*
nohup.out
.vale.ini
styles/
/.vscode
.idea
node_modules/
silicon-*
build_rust/
build_c_cpp/
build_go/
flamegraph/
flamegraph.svg
perf.data*
]]

return {
    s(
        {
            trig = "tex",
            priority = 30000,
            dscr = "tex ignore",
        },
        fmta([[
### TeX
## Core latex/pdflatex auxiliary files:
*.aux
*.lof
*.log
*.lot
*.fls
*.out
*.toc
*.fmt
*.fot
*.cb
*.cb2
.*.lb

## Intermediate documents:
*.dvi
*.xdv
*-converted-to.*
# these rules might exclude image files for figures etc.
# *.ps
# *.eps
# *.pdf

## Generated if empty string is given at "Please type another file name for output:"
.pdf

## Bibliography auxiliary files (bibtex/biblatex/biber):
*.bbl
*.bcf
*.blg
*-blx.aux
*-blx.bib
*.run.xml

## Build tool auxiliary files:
*.fdb_latexmk
*.synctex
*.synctex(busy)
*.synctex.gz
*.synctex.gz(busy)
*.pdfsync

## Build tool directories for auxiliary files
# latexrun
latex.out/

## Auxiliary and intermediate files from other packages:
# algorithms
*.alg
*.loa

# achemso
acs-*.bib

# amsthm
*.thm

# beamer
*.nav
*.pre
*.snm
*.vrb

# changes
*.soc

# comment
*.cut

# cprotect
*.cpt

# elsarticle (documentclass of Elsevier journals)
*.spl

# endnotes
*.ent

# fixme
*.lox

# feynmf/feynmp
*.mf
*.mp
*.t[1-9]
*.t[1-9][0-9]
*.tfm

#(r)(e)ledmac/(r)(e)ledpar
*.end
*.?end
*.[1-9]
*.[1-9][0-9]
*.[1-9][0-9][0-9]
*.[1-9]R
*.[1-9][0-9]R
*.[1-9][0-9][0-9]R
*.eledsec[1-9]
*.eledsec[1-9]R
*.eledsec[1-9][0-9]
*.eledsec[1-9][0-9]R
*.eledsec[1-9][0-9][0-9]
*.eledsec[1-9][0-9][0-9]R

# glossaries
*.acn
*.acr
*.glg
*.glo
*.gls
*.glsdefs
*.lzo
*.lzs
*.slg
*.slo
*.sls

# uncomment this for glossaries-extra (will ignore makeindex's style files!)
# *.ist

# gnuplot
*.gnuplot
*.table

# gnuplottex
*-gnuplottex-*

# gregoriotex
*.gaux
*.glog
*.gtex

# htlatex
*.4ct
*.4tc
*.idv
*.lg
*.trc
*.xref

# hyperref
*.brf

# knitr
*-concordance.tex
# TODO Uncomment the next line if you use knitr and want to ignore its generated tikz files
# *.tikz
*-tikzDictionary

# listings
*.lol

# luatexja-ruby
*.ltjruby

# makeidx
*.idx
*.ilg
*.ind

# minitoc
*.maf
*.mlf
*.mlt
*.mtc[0-9]*
*.slf[0-9]*
*.slt[0-9]*
*.stc[0-9]*

# minted
_minted*
*.pyg

# morewrites
*.mw

# newpax
*.newpax

# nomencl
*.nlg
*.nlo
*.nls

# pax
*.pax

# pdfpcnotes
*.pdfpc

# sagetex
*.sagetex.sage
*.sagetex.py
*.sagetex.scmd

# scrwfile
*.wrt

# svg
svg-inkscape/

# sympy
*.sout
*.sympy
sympy-plots-for-*.tex/

# pdfcomment
*.upa
*.upb

# pythontex
*.pytxcode
pythontex-files-*/

# tcolorbox
*.listing

# thmtools
*.loe

# TikZ & PGF
*.dpth
*.md5
*.auxlock

# titletoc
*.ptc

# todonotes
*.tdo

# vhistory
*.hst
*.ver

# easy-todo
*.lod

# xcolor
*.xcp

# xmpincl
*.xmpi

# xindy
*.xdy

# xypic precompiled matrices and outlines
*.xyc
*.xyd

# endfloat
*.ttt
*.fff

# Latexian
TSWLatexianTemp*

## Editors:
# WinEdt
*.bak
*.sav

# Texpad
.texpadtmp

# LyX
*.lyx~

# Kile
*.backup

# gummi
.*.swp

# KBibTeX
*~[0-9]*

# TeXnicCenter
*.tps

# auto folder when using emacs and auctex
./auto/*
*.el

# expex forward references with \gathertags
*-tags.tex

# standalone packages
*.sta

# Makeindex log files
*.lpz

# xwatermark package
*.xwm

# REVTeX puts footnotes in the bibliography by default, unless the nofootinbib
# option is specified. Footnotes are the stored in a file with suffix Notes.bib.
# Uncomment the next line to have this generated file ignored.
#*Notes.bib

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "lua",
            priority = 30000,
            dscr = "lua ignore",
        },
        fmta([[
### Lua
# Compiled Lua sources
luac.out

# luarocks build files
*.src.rock
*.zip
*.tar.gz

# Object files
*.o
*.os
*.ko
*.obj
*.elf

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo
*.def
*.exp

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "dart",
            priority = 30000,
            dscr = "dart ignore",
        },
        fmta([[
### Dart
# See https://www.dartlang.org/guides/libraries/private-files

# Files and directories created by pub
.dart_tool/
.packages
build/
# If you're building an application, you may want to check-in your pubspec.lock
pubspec.lock

# Directory created by dartdoc
# If you don't generate documentation locally you can remove this line.
doc/api/

# dotenv environment variables file
.env*

# Avoid committing generated Javascript files:
*.dart.js
*.info.json      # Produced by the --dump-info flag.
*.js             # When generated by dart2js. Don't specify *.js if your
                 # project includes source files written in JavaScript.
*.js_
*.js.deps
*.js.map

.flutter-plugins
.flutter-plugins-dependencies

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "java",
            priority = 30000,
            dscr = "java ignore",
        },
        fmta([[
### Java
# Compiled class file
*.class

# Log file
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files #
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
replay_pid*

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "go",
            priority = 30000,
            dscr = "go ignore",
        },
        fmta([[
### Go
# If you prefer the allow list template instead of the deny list, see community template:
# https://github.com/github/gitignore/blob/main/community/Golang/Go.AllowList.gitignore
#
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Dependency directories (remove the comment below to include it)
# vendor/

# Go workspace file
go.work

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "cpp",
            priority = 30000,
            dscr =   "cpp ignore",
        },
        fmta([[
### C++
# Prerequisites
*.d

# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod
*.smod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "c",
            priority = 30000,
            dscr =  "c ignore",
        },
        fmta([[
### C
# Prerequisites
*.d

# Object files
*.o
*.ko
*.obj
*.elf

# Linker output
*.ilk
*.map
*.exp

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# Kernel Module Compile Results
*.mod*
*.cmd
.tmp_versions/
modules.order
Module.symvers
Mkfile.old
dkms.conf

]] .. mis, {}, {})
    ),
    s(
        {
            trig = "rust",
            priority = 30000,
            dscr = "rust ignore",
        },
        fmta([[
### Rust
# Generated by Cargo
# will have compiled files and executables
debug/
/target

# About test file
*.profraw

# These are backup files generated by rustfmt
**/*.rs.bk

rustc-ice*

<>

]] .. mis, { i(1, [[Cargo.lock]]) }, {})
    ),
    s({
        trig = "mis",
        priority = 30000,
        dscr = "mis ignore",
    }, fmta(mis, {}, {})),
}
