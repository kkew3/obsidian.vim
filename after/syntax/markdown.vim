" Dependent on https://github.com/preservim/vim-markdown

if get(b:, "under_obsidian_vault", 0)

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


    syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdBookmarkHash,mkdLink,mkdLinkDef,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike,mkdMark,mkdWikiLink



    hi def link mkdHeadingDelimiter Delimiter
    hi def link mkdBookmarkHash Comment
    hi def link mkdDelimiter Comment
    hi def link mkdWikiLink htmlLink

endif
