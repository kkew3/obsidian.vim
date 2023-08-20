" Heavily based on https://github.com/preservim/vim-markdown


" Read the HTML syn to start with
if v:version < 600
    source <sfile>:p:h/html.vim
else
    runtime! syntax/html.vim

    if exists('b:current_syntax')
        unlet b:current_syntax
    endif
endif

if v:version < 600
    syn clear
elseif exists('b:current_syntax')
    finish
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 0)
    let s:conceal = ' conceal'
    let s:concealends = ' concealends'
endif
if has('conceal') && get(g:, 'vim_markdown_conceal_code_blocks', 0)
    let s:concealcode = ' concealends'
endif

if get(g:, 'vim_markdown_emphasis_multiline', 1)
    let s:oneline = ''
else
    let s:oneline = ' oneline'
endif

" emphasis
execute 'syn region htmlItalic matchgroup=obmarkdownDelimiter start="\%(^\|\s\)\zs\*\ze[^\\\*\t ]\%(\%([^*]\|\\\*\|\n\)*[^\\\*\t ]\)\?\*\_W" end="[^\\\*\t ]\zs\*\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlItalic matchgroup=obmarkdownDelimiter start="\%(^\|\s\)\zs_\ze[^\\_\t ]" end="[^\\_\t ]\zs_\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs\*\*\ze\S" end="\S\zs\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs__\ze\S" end="\S\zs__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs\*\*\*\ze\S" end="\S\zs\*\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs\*\*_\ze\S" end="\S\zs_\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs\*__\ze\S" end="\S\zs__\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs___\ze\S" end="\S\zs___" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs__\*\ze\S" end="\S\zs\*__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=obmarkdownDelimiter start="\v(^|\s)\zs_\*\*\ze\S" end="\S\zs\*\*_" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlStrike matchgroup=obmarkdownDelimiter start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
execute 'syn region obmarkdownMark matchgroup=obmarkdownDelimiter start="\v(\=\=)" end="\v(\=\=)"' . s:concealends

" headings
syn region htmlH1 matchgroup=obmarkdownHeadingDelimiter start="\v^# " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell
syn region htmlH2 matchgroup=obmarkdownHeadingDelimiter start="\v^## " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell
syn region htmlH3 matchgroup=obmarkdownHeadingDelimiter start="\v^### " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell
syn region htmlH4 matchgroup=obmarkdownHeadingDelimiter start="\v^#### " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell
syn region htmlH5 matchgroup=obmarkdownHeadingDelimiter start="\v^##### " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell
syn region htmlH6 matchgroup=obmarkdownHeadingDelimiter start="\v^###### " end="\v$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell

" bookmark hash
syn match obmarkdownBookmarkHash "\v(^|\s+)\^[0-9a-zA-Z]+(\n{2,}|%$)"

" hyperlink, image link
execute 'syn region obmarkdownID matchgroup=obmarkdownDelimiter    start="\["    end="\]" contained oneline' . s:conceal
execute 'syn region obmarkdownURL matchgroup=obmarkdownDelimiter   start="("     end=")"  contained oneline' . s:conceal
execute 'syn region obmarkdownLink matchgroup=obmarkdownDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@obmarkdownNonListItem,@Spell nextgroup=obmarkdownURL,obmarkdownID skipwhite' . s:concealends

" link definitions
syn region obmarkdownLinkDef matchgroup=obmarkdownDelimiter   start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=obmarkdownLinkDefTarget skipwhite
syn region obmarkdownLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=obmarkdownLinkDef skipwhite skipnl oneline

" wikilink
syn region obmarkdownWikiLink matchgroup=obmarkdownDelimiter start="\\\@<!!\?\[\[\ze\(\([^]\n]\+\)\)" end="\]\]" oneline

" YAML frontmatter
syn include @yamlTop syntax/yaml.vim
syn region obmarkdownYAMLMatter matchgroup=obmarkdownDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend
unlet! b:current_syntax

" math
syn include @tex syntax/tex.vim
syn region obmarkdownMath matchgroup=obmarkdownDelimiter start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
syn region obmarkdownMath matchgroup=obmarkdownDelimiter start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend
unlet b:current_syntax

" blockquote
syn region obmarkdownBlockquote matchgroup=obmarkdownDelimiter start="^>" end="$" contains=obmarkdownLink,obmarkdownWikiLink,obmarkdownBookmarkHash,@Spell

" code
execute 'syn region obmarkdownCode matchgroup=obmarkdownCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/ end=/`/' . s:concealcode
execute 'syn region obmarkdownCode matchgroup=obmarkdownCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/ end=/``/' . s:concealcode
execute 'syn region obmarkdownCode matchgroup=obmarkdownCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/ end=/^\s*\z1`*\s*$/' . s:concealcode
execute 'syn region obmarkdownCode matchgroup=obmarkdownCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/ end=/\(\([^\\]\|^\)\\\)\@<!\~\~/' . s:concealcode
execute 'syn region obmarkdownCode matchgroup=obmarkdownCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/ end=/^\s*\z1\~*\s*$/' . s:concealcode
syn match  obmarkdownCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  obmarkdownCode         /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  obmarkdownCode         /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained

" lists
syn match  obmarkdownListItem     /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained nextgroup=obmarkdownListItemCheckbox
syn match  obmarkdownListItemCheckbox     /\[[xXoO ]\]\ze\s\+/ contained contains=obmarkdownListItem
syn region obmarkdownListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@obmarkdownNonListItem,obmarkdownListItem,obmarkdownListItemCheckbox,@Spell

" ruler
syn match obmarkdownRule /\n\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/
syn match obmarkdownRule /\n\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/
syn match obmarkdownRule /\n\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/


syn cluster obmarkdownNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,obmarkdownBookmarkHash,obmarkdownLink,obmarkdownLinkDef,obmarkdownBlockquote,obmarkdownCode,obmarkdownRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,obmarkdownMath,obmarkdownStrike,obmarkdownMark,obmarkdownWikiLink



hi def link obmarkdownHeadingDelimiter Delimiter
hi def link obmarkdownBookmarkHash Comment
hi def link obmarkdownURL Float
hi def link obmarkdownLink htmlLink
hi def link obmarkdownID Identifier
hi def link obmarkdownDelimiter Comment
hi def link obmarkdownLinkDef obmarkdownID
hi def link obmarkdownLinkDefTarget obmarkdownURL
hi def link obmarkdownWikiLink htmlLink
hi def link obmarkdownYAMLMatter Comment
hi def link obmarkdownMark Type
hi def link obmarkdownCode String
hi def link obmarkdownCodeDelimiter String
hi def link obmarkdownListItem Identifier
hi def link obmarkdownListItemCheckbox Identifier
hi def link obmarkdownRule Identifier

" used elsewhere
hi def link obmarkdownCodeStart String
hi def link obmarkdownCodeEnd String


let b:current_syntax = "obsidian_markdown"
