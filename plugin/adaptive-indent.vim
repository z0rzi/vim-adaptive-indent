

function! s:baba()
    let firstIndentLine = getline(search("^[[:blank:]]", "n"))

    let indent = matchstr(firstIndentLine, '^\s\+\ze\S')

    if indent =~ ' \+'
        let l = len(indent)
        exe "set tabstop=".l." shiftwidth=".l." expandtab"
    elseif indent =~ '\t\+'
        exe "set tabstop=4 shiftwidth=4 noexpandtab"
    endif

    let g:tmp_ind = indent
endfunction

au BufReadPost * call s:baba()