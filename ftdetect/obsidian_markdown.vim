if !has('python3')
    echoerr "python3 is required"
    finish
endif

function! s:FtDetect()
    py3 obsidian.ftdetect()
endfunction

autocmd BufRead,BufNewFile *.md call s:FtDetect()
