;; extends

;(("for" @keyword) (#set! conceal "F"))
(("function" @keyword.function) (#set! conceal "󰊕"))
;(("if" @conditional) (#set! conceal "?"))
(("in" @keyword) (#set! conceal "∈"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal "󰋺"))
(("and" @keyword.function) (#set! conceal "⩓"))
(("not" @keyword.function) (#set! conceal "❗"))

;(("return" @keyword.function) (#set! conceal "R"))
;(("do" @repeat) (#set! conceal "d"))
; (("else" @conditional) (#set! conceal "e"))
; (("elseif" @conditional) (#set! conceal "e"))
; (("end" @keyword.function) (#set! conceal "E"))
(("then" @conditional) (#set! conceal ""))
