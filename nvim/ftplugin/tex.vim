scriptencoding utf-8

function! ZathuraOpenPdf()
	let fullPath = expand('%:p')
	let pdfFile = substitute(fullPath, '.tex', '.pdf', '')
	execute "silent !zathura '" . pdfFile . "' &"
endfunction

nnoremap <A-b> :call ZathuraOpenPdf()<CR>
