" Dependent on https://github.com/preservim/vim-markdown

let s:concealends = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 1)
    let s:conceal = ' conceal'
    let s:concealends = ' concealends'
endif

function! s:PatchObsidianSyntax()
    " emphasis
    execute 'syn region mkdMark matchgroup=mkdDelimiter start="\v(\=\=)" end="\v(\=\=)"' . s:concealends
    if !get(g:, 'vim_markdown_strikethrough', 0)
        execute 'syn region mkdStrike matchgroup=mkdDelimiter start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
    endif

    " headings
    syn region htmlH1 matchgroup=mkdHeadingDelimiter start="\v^# " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell
    syn region htmlH2 matchgroup=mkdHeadingDelimiter start="\v^## " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell
    syn region htmlH3 matchgroup=mkdHeadingDelimiter start="\v^### " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell
    syn region htmlH4 matchgroup=mkdHeadingDelimiter start="\v^#### " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell
    syn region htmlH5 matchgroup=mkdHeadingDelimiter start="\v^##### " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell
    syn region htmlH6 matchgroup=mkdHeadingDelimiter start="\v^###### " end="\v$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell

    " bookmark hash
    syn match mkdBookmarkHash "\v(^|\s+)\^[0-9a-zA-Z]+(\n{1,}|%$)"

    " wikilink
    syn region mkdWikiLink matchgroup=mkdDelimiter start="\\\@<!!\?\[\[\ze\(\([^]\n]\+\)\)" end="\]\]" contains=mkdWikiAltName oneline
    syn region mkdWikiAltName matchgroup=mkdDelimiter start="|" end="\ze\]\]" contained

    " blockquote
    syn region mkdBlockquote matchgroup=mkdDelimiter start="^>" end="$" contains=mkdLink,mkdWikiLink,mkdBookmarkHash,@Spell

    " YAML frontmatter
    if !get(g:, 'vim_markdown_frontmatter', 0)
        unlet! b:current_syntax
        syn include @yamlTop syntax/yaml.vim
        syn region Comment matchgroup=mkdDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend
    endif

    " math
    if !get(g:, 'vim_markdown_math', 0)
        unlet! b:current_syntax
        syn include @tex syntax/tex.vim
        syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
        syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend
    endif


    syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdBookmarkHash,mkdLink,mkdLinkDef,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike,mkdMark,mkdWikiLink



    hi def link mkdMark Type
    hi def link mkdHeadingDelimiter Delimiter
    hi def link mkdBookmarkHash Comment
    hi def link mkdDelimiter Comment
    hi def link mkdWikiLink htmlLink

    let b:current_syntax = 'mkd'
endfunction

if get(b:, "under_obsidian_vault", 0)
    call s:PatchObsidianSyntax()
endif
