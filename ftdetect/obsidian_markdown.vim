if !has('python3')
    echomsg "python3 is required"
    finish
endif

function! s:FtDetect()
    py3 << EOF
import ftdetect
ftdetect.ftdetect()
EOF
endfunction

autocmd BufRead,BufNewFile *.md call s:FtDetect()
