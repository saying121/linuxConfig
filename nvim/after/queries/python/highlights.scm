;; extends

; (("assert"       @keyword) (#set! conceal "?"))
; (("continue"     @keyword) (#set! conceal "C"))
; (("break"        @keyword) (#set! conceal "B"))
; (("del"          @keyword) (#set! conceal "D"))
; (("yield"        @keyword) (#set! conceal "Y"))
; (("pass"         @keyword) (#set! conceal "P"))
; ((yield ("from") @keyword) (#set! conceal "F"))
; (("with"         @keyword) (#set! conceal "w"))
; (("return"       @keyword) (#set! conceal "R"))
; (("global"       @keyword) (#set! conceal "G"))
; (("else"         @conditional) (#set! conceal "e"))
; (("if"           @conditional) (#set! conceal "?"))
; (("elif"         @conditional) (#set! conceal "e"))
(("import"       @include) (#set! conceal "󰼟"))
((import_from_statement ("from") @include) (#set! conceal "󰼠"))
; (("while"        @repeat) (#set! conceal "W"))

((aliased_import
   "as" @keyword.import) (#set! conceal "≍"))

(("class"        @keyword) (#set! conceal "𝑪"))
(("def"          @keyword.function) (#set! conceal "󰊕"))
(("lambda"       @include) (#set! conceal "λ"))
(("in"           @keyword) (#set! conceal "∈"))
(("and"          @keyword.operator) (#set! conceal "⩓"))
(("or"           @keyword.operator) (#set! conceal "⩔"))
(("not"          @keyword.operator) (#set! conceal "❗")) ; ❕

((">=" @operator) (#set! conceal "󰥮"))
(("<=" @operator) (#set! conceal "󰥽"))
(("!=" @operator) (#set! conceal "󰦎"))
(("//" @operator) (#set! conceal "÷")) ; 跟其他语言相同功能的/保持一致
;(("*" @operator) (#set! conceal "✖"))
;(("**" @operator) (#set! conceal "t"))
