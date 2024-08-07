scriptencoding utf-8

" 当前行高亮
set cursorline
augroup CursorLine
    autocmd!
    autocmd WinEnter,InsertLeave * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
augroup END

augroup RecoverCursor
    autocmd!
    " 恢复光标位置
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

" 写入自动删除行末空格
augroup blank
    autocmd!
    autocmd BufWrite * :%s/\s\+$//e
augroup END

" 自动创建视图
" augroup views
"     autocmd!
"     autocmd BufWrite * mkview
"     autocmd BufWinLeave * mkview
"     autocmd BufRead * silent loadview
" augroup END

augroup File
    autocmd!
    " 自动赋予执行权限
    autocmd BufWritePost *.sh,*.py,*.awk,*.zsh silent !chmod +x %
    " 读取模板
    autocmd BufNewFile *.sh silent 0r ~/.config/nvim/viml/template/bash.sh     | normal G
    autocmd BufNewFile *.zsh silent 0r ~/.config/nvim/viml/template/zsh.zsh    | normal G
    autocmd BufNewFile *.py silent 0r ~/.config/nvim/viml/template/python3.py  | normal G
    autocmd BufNewFile *.html silent 0r ~/.config/nvim/viml/template/html.html | normal Gdd4G16|
    autocmd BufNewFile *.vim silent 0r ~/.config/nvim/viml/template/vim.vim    | normal G
    autocmd BufNewFile *.awk silent 0r ~/.config/nvim/viml/template/awk.awk    | normal G
augroup END
