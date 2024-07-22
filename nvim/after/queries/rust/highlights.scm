;; extends

(("fn"       @keyword.function) (#set! conceal "󰊕"))

(("use" @keyword.import) (#set! conceal ""))
;(("mod" @keyword.import) (#set! conceal "󰕳"))

;(("default" @keyword) (#set! conceal "󰕳"))
(("impl" @keyword) (#set! conceal "󰹶"))
;(("let" @keyword) (#set! conceal "󱄑"))
(("move" @keyword) (#set! conceal ""))
(("unsafe" @keyword) (#set! conceal ""))
;(("where" @keyword) (#set! conceal "🧘"))

(("in"       @keyword.repeat) (#set! conceal "∈"))
(("loop"     @keyword.repeat) (#set! conceal ""))
(("continue" @keyword.repeat) (#set! conceal ""))

; (("enum" @keyword.type) (#set! conceal ""))
; (("struct" @keyword.type) (#set! conceal ""))

(("as" @keyword.operator) (#set! conceal "≍"))


(("||" @operator) (#set! conceal "∨"))
(("&&" @operator) (#set! conceal "∧"))
((">=" @operator) (#set! conceal "󰥮"))
(("<=" @operator) (#set! conceal "󰥽"))
(("!=" @operator) (#set! conceal "󰦎"))
;(("!" @operator) (#set! conceal "❗")) ; 宏的!也被换了
(("/" @operator) (#set! conceal "÷"))
; (("*" @operator) (#set! conceal "✖")) ; 裸指针的也换掉了

; (("->" @punctuation.delimiter) (#set! conceal "→"))
; (("=>" @punctuation.delimiter) (#set! conceal "⇒"))
;(("::" @punctuation.delimiter) (#set! conceal ""))

; (("dyn" @keyword.modifier) (#set! conceal ""))
; (("static" @keyword.modifier) (#set! conceal ""))
; (("const" @keyword.modifier) (#set! conceal "🚧"))
; (("pub" @keyword.modifier) (#set! conceal ""))
(("extern" @keyword.modifier) (#set! conceal ""))
(("ref" @keyword.modifier) (#set! conceal ""))


;((lifetime "'" @keyword.modifier) (#set! conceal "⊗"))

; ((for_lifetimes
;    [
;     "<"
;     ">"
;     ] @punctuation.bracket) (#set! conceal "󱎫"))
