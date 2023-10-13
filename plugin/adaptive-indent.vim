
function! <SID>AutoSetIndent()
    let line = nextnonblank(1)
    let indent = indent(line)
    let prev_indent = indent(line)
    let dict = {}

    let amounts_of_tabs_indents = 0
    let amounts_of_space_indents = 0
    
    while line != 0
        let indent = indent(line)
        if indent > prev_indent
            let indent_diff = indent - prev_indent
            let dict[indent_diff] = get(dict, indent_diff, 0) + 1
        endif

        if getline(line)[0] == ' '
            let amounts_of_space_indents += 1
        elseif getline(line)[0] == "\<TAB>"
            let amounts_of_tabs_indents += 1
        endif

        let prev_indent = indent
        let line = nextnonblank(line + 1)
    endwhile

    let max_indent = 0

    for indent in keys(dict)
        if get(dict, max_indent, 0) < dict[indent]
            let max_indent = indent
        endif
    endfor

    let indents_are_tabs = amounts_of_tabs_indents > amounts_of_space_indents

    if !max_indent
        let max_indent = 4
    endif

    exe "set tabstop=" . max_indent . " shiftwidth=" . max_indent . " " . (indents_are_tabs?"noexpandtab":"expandtab")
    echo &tabstop
endfunction


command! -bar -nargs=0 AdaptIndent call <SID>AutoSetIndent()

