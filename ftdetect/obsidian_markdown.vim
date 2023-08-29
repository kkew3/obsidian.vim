if !has('python3')
    echoerr "python3 is required"
    finish
endif

autocmd BufRead,BufNewFile *.md call py3eval("obsidian.reload_syntax_if_under_obsidian_vault()")
