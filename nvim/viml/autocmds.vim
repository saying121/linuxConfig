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
    autocmd BufWritePost *.sh,*.py,*.lua,*.awk silent !chmod +x %
    " 读取模板
    autocmd BufNewFile *.sh silent 0r ~/.config/nvim/viml/template/shell.txt | normal G
    autocmd BufNewFile *.zsh silent 0r ~/.config/nvim/viml/template/zsh.txt | normal G
    autocmd BufNewFile *.py silent 0r ~/.config/nvim/viml/template/python3.txt| normal G
    autocmd BufNewFile *.html silent 0r ~/.config/nvim/viml/template/html.txt| normal Gdd4G16|
    autocmd BufNewFile *.vim silent 0r ~/.config/nvim/viml/template/vim.txt| normal G
    autocmd BufNewFile *.awk silent 0r ~/.config/nvim/viml/template/awk.txt| normal G
augroup END

" augroup EventLoggin
"   autocmd!
"   autocmd BufNewFile * call s:Log ('BufNewFile')
"   autocmd BufReadPre * call s:Log ('BufReadPre')
"   autocmd BufReadPre * call s:Log ('BufReadPre')
"   autocmd User * call s:Log ('User')
" augroup END
"
" function! s:Log (eventName) abort
"   silent execute '!echo '.a:eventName.' >>~/temp/vim.log'
" endfunction

" 打开二进制文件，已知nvim 打不开 pdf
if exists('g:did_load_filetypes')
    if executable('lesspipe.sh')
        let s:lesspipe_cmd = 'LESSQUIET=1 lesspipe.sh'
    elseif executable('lesspipe')
        let s:lesspipe_cmd = 'lesspipe'
    endif
    if exists('s:lesspipe_cmd') && executable('file')
        augroup lesspipe
            autocmd!
            autocmd BufReadPost *
                \ if empty(&l:buftype) && !did_filetype() && !&l:binary && filereadable(bufname('%')) &&
                \   system('file --mime --brief ' . fnamemodify(resolve(expand('%')), ':p:S')) !~# '^text/' |
                \   silent exe '%!' . s:lesspipe_cmd . ' ' . expand('%:S') |
                \   setlocal filetype=text nomodifiable readonly |
                \ endif
        augroup END
    endif
endif

let g:zipPlugin_ext='*.apk,*.celzip,*.crtx,*.ear,*.gcsx,*.glox,*.gqsx,*.kmz,*.oxt,*.potm,*.potx,*.ppam,*.sldx,*.thmx,*.vdw,*.war,*.wsz,*.xap,*.xlam,*.xlam,*.xltm,*.xltx,*.xpi,*.zip'
