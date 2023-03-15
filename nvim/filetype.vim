augroup filetypedetect
    au!
    au BufNewFile,BufRead *.log     setfiletype log
    au BufNewFile,BufRead *.yuck     setfiletype yuck
augroup END
