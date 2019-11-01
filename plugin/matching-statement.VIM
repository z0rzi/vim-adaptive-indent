

function! ComparePositions(pos1, pos2)
    if a:pos1[0] < a:pos2[0]
        return 1
    endif
    if a:pos1[0] > a:pos2[0]
        return -1
    endif
    if a:pos1[1] < a:pos2[1]
        return 1
    endif
    if a:pos1[1] > a:pos2[1]
        return -1
    endif
    return 0
endfunction

function! MatchStatement(beg, end)
    let g:stack = 1

    let security = 0

    call setpos("'m", getpos('.'))
    let maybeBegPos = searchpos(a:end, 'cbW')
    let maybeEndPos = searchpos(a:end, 'cneW')
    call setpos('.', getpos("'m"))
    let cursorPos = getpos(".")[1:2]

    let g:reversed = 0
    if maybeBegPos[0] != 0 && maybeEndPos[0] != 0 && ComparePositions(cursorPos, maybeEndPos) >= 0 && ComparePositions(maybeBegPos, cursorPos) >= 0
        let g:reversed = 1
        call setpos('.', [0] + maybeBegPos + [0])
    endif
    
    let flags = 'Wn'

    if g:reversed
        let flags .= 'b'
    endif

    while 1
        
        let begPos = searchpos(a:beg, flags)
        let endPos = searchpos(a:end, flags)

        if g:reversed
            if ComparePositions( endPos, begPos ) == 1 || endPos[0] == 0
                let g:stack -= 1
                call setpos('.', [0] + begPos + [0])
            else
                let g:stack += 1
                call setpos('.', [0] + endPos + [0])
            endif

            if g:stack <= 0
                break
            endif
        else
            if ComparePositions( endPos, begPos ) == 1 || begPos[0] == 0
                let g:stack -= 1
                call setpos('.', [0] + endPos + [0])
            else
                let g:stack += 1
                call setpos('.', [0] + begPos + [0])
            endif

            if g:stack <= 0
                break
            endif
        endif

        let security += 1

        if security > 1000
            break
        endif
    endwhile
endfunction

function! FindRightCouple()
    let ext = expand('%')
    let all_couples = readfile("/home/zorzi/.vim/bundle/vim-matching-statement/plugin/php.matches")

    let right_couple = []
    for couple in all_couples
        let rxs = [ matchstr(couple, '^.*\ze\s\+'), matchstr(couple, '\s\+\zs.*$') ]

        for rx in rxs

            call setpos("'m", getpos('.'))
            let maybeBegPos = searchpos(rx, 'cbW')
            let maybeEndPos = searchpos(rx, 'cneW')
            call setpos('.', getpos("'m"))
            let cursorPos = getpos(".")[1:2]

            if maybeBegPos[0] != 0 && maybeEndPos[0] != 0 && ComparePositions(cursorPos, maybeEndPos) >= 0 && ComparePositions(maybeBegPos, cursorPos) >= 0
                let right_couple = rxs
                break
            endif
        endfor
    endfor

    if len( right_couple )
        let g:couple = right_couple
        call MatchStatement(right_couple[0], right_couple[1])
    endif

endfunction

nnoremap gr :call FindRightCouple()<CR>
