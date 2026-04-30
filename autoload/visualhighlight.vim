vim9script noclear

export def Enable(): void
  call MatchAdd()
  augroup VisualHighlightImpl | autocmd!
    autocmd CursorMoved * call MatchAdd()
  augroup END
enddef

export def Disable(): void
  augroup VisualHighlightImpl | autocmd!
  augroup END
  call matchdelete(g:visualhighlight_id)
enddef

def MatchAdd(): void
  try
    call matchdelete(g:visualhighlight_id)
  catch
  endtry
  const [b, e] = sort([getcharpos('v')[1 : 2], getcharpos('.')[1 : 2]], 'LexComp')
  const ee = e[1] - getline(e[0])->strchars() - 1
  const str = getline(b[0], e[0])
    \ ->join(' ')[b[1] - 1 : ee]
    \ ->substitute('\_s\+', '\\_s\\+', 'g')
  if ee != 0
    const ic = &ignorecase ? '\c' : '\C'
    call matchadd('VisualHighlightGroup', '\V' .. ic .. str, 0, g:visualhighlight_id)
  endif
enddef

def LexComp(a: list<number>, b: list<number>): number
  if a->empty()
    return b->empty() ? 0 : -1
  elseif b->empty()
    return 1
  else
    const d = a[0] - b[0]
    return d != 0 ? d : LexComp(a[1 :], b[1 :])
  endif
enddef
