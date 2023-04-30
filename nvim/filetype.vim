scriptencoding utf-8

" set fileignorecase

augroup FileTypeDetect
    au!
    au BufNewFile,BufRead *.log         setfiletype log
    au BufNewFile,BufRead *.yuck        setfiletype yuck
    au BufNewFile,BufRead *.typ         setfiletype typst
    au BufNewFile,BufRead \cLICENSE     setfiletype license " \c不检测大小写
augroup END
