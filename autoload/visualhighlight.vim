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
  call MatchDel()
enddef

var visualhighlight_win_ids = []
var visualhighlight_match_ids = []

def MatchDel()
  visualhighlight_win_ids->map((k, wid) => matchdelete(visualhighlight_match_ids[k], wid))
  visualhighlight_win_ids = []
enddef

def MatchAdd(): void
  call MatchDel()
  const [b, e] = sort([getcharpos('v')[1 : 2], getcharpos('.')[1 : 2]], 'LexComp')
  const ee = e[1] - getline(e[0])->strchars() - 1
  if ee == 0
    return
  endif
  const lines = getline(b[0], e[0])
  var str = lines->join(' ')[b[1] - 1 : ee]
  if lines->len() != 1 || str->match('^\s\+$') != 0
    str = str ->substitute('\\', '\\\\', 'g')
            \ ->substitute('\_s\+', '\\_s\\+', 'g')
  endif
  const ic = &ignorecase ? '\c' : '\C'
  str = '\V' .. ic .. str
  visualhighlight_win_ids = getwininfo()->filter((_, wi) => wi.tabnr == tabpagenr())
                                      \ ->map((_, wi) => wi.winid)
  visualhighlight_match_ids = visualhighlight_win_ids
        \ ->mapnew((_, wid) => matchadd('VisualHighlightGroup', str, 0, -1, { 'window': wid }))
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
