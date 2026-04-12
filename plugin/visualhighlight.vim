vim9script noclear

import autoload 'visualhighlight.vim' as Impl

if exists('g:loaded_visualhighlight')
  finish
endif
g:loaded_visualhighlight = 1

                      highlight default VisualHighlightGroup cterm=underline ctermfg=green
autocmd ColorScheme * highlight default VisualHighlightGroup cterm=underline ctermfg=green

var nothing = '\(a*\)\@>a'
g:visualhighlight_id = matchadd('VisualHighlightGroup', nothing)

augroup VisualHighlight | autocmd!
  autocmd ModeChanged *:v call Impl.Enable()
  autocmd ModeChanged v:* call Impl.Disable()
augroup END
