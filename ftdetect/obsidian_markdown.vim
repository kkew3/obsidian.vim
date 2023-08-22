if !has('python3')
    echoerr "python3 is required"
    finish
endif

function! s:FtDetect()
    py3 obsidian.reload_syntax_if_under_obsidian_vault()
endfunction

autocmd BufRead,BufNewFile *.md call s:FtDetect()
