
function! <SID>AutoSetIndent()
    let view = winsaveview()

    call setpos('.', [0, 1, 1, 0])
    let acceptedChars = 'a-zA-Z{}[\]()._:<>#"''@'
                
    let firstIndentLine = getline(search('\v%^((\s.*|\s*[^'.acceptedChars.'[:blank:]].*|['.acceptedChars.'].*)?\n){-}\zs\s+\ze['.acceptedChars.']', 'n', 200))

    let indent = matchstr(firstIndentLine, '^\s\+\ze\S')

    if indent =~ ' \+'
        let l = len(indent)
        exe "set tabstop=".l." shiftwidth=".l." expandtab"
    elseif indent =~ '\t\+'
        exe "set tabstop=4 shiftwidth=4 noexpandtab"
    else
        exe "set tabstop=4 shiftwidth=4 expandtab"
    endif

    call winrestview(view)
endfunction


command! -bar -nargs=0 AdaptIndent call <SID>AutoSetIndent()
