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
  var [b, e] = sort([getcharpos('v')[1 : 2], getcharpos('.')[1 : 2]], 'LexComp')
  var str = getline(b[0], e[0])->join('\n')[b[1] - 1 : e[1] - getline(e[0])->strchars() - 1]
  var ic = &ignorecase ? '\c' : '\C'
  try
    call matchdelete(g:visualhighlight_id)
  catch
  endtry
  call matchadd('VisualHighlightGroup', ic .. str, 0, g:visualhighlight_id)
enddef

def LexComp(a: list<number>, b: list<number>): number
  if a->empty()
    return b->empty() ? 0 : -1
  elseif b->empty()
    return 1
  else
    var d = a[0] - b[0]
    return d != 0 ? d : LexComp(a[1 :], b[1 :])
  endif
enddef
