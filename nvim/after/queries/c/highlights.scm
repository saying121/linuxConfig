;; extends 

(((declaration (type_qualifier) @keyword) (#eq? @keyword "const")) (#set! conceal "C"))
(((declaration type: (primitive_type) @type) (#eq? @type "char")) (#set! conceal "c"))
