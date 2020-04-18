function! <SID>AutoSetIndent()
    let firstIndentLine = getline(search('\v%^((\S.*|\s*[^a-zA-Z{}[\]()._].*)?\n){-}\zs\s+\ze[a-zA-Z{}[\]()._]', 'n'))


    let indent = matchstr(firstIndentLine, '^\s\+\ze\S')

    if indent =~ ' \+'
        let l = len(indent)
        exe "set tabstop=".l." shiftwidth=".l." expandtab"
    elseif indent =~ '\t\+'
        exe "set tabstop=4 shiftwidth=4 noexpandtab"
    else
        exe "set tabstop=4 shiftwidth=4 expandtab"
    endif
endfunction


command! -bar -nargs=0 AdaptIndent call <SID>AutoSetIndent()
