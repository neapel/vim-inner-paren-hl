" inspired by https://github.com/haruyama/vim-matchopen

if exists("g:loaded_inner_paren_hl") || &cp || !exists("##CursorMoved")
	finish
endif
let g:loaded_inner_paren_hl = 1

let g:inner_paren_hl_searchpairpos_timeout = get(g:, 'inner_paren_hl_searchpairpos_timeout', 10)

augroup inner_paren_hl
	autocmd! CursorMoved,CursorMovedI,WinEnter * call s:inner_paren_hl_do()
augroup END

if exists("*s:inner_paren_hl_do")
	finish
endif


let s:cpo_save = &cpo
set cpo-=C

" customize this.
" TODO: automatic subtly-off colors
" -> https://github.com/nathanaelkane/vim-indent-guides/
highlight innerparenhlSpan guibg=#ffffff

function! s:inner_paren_hl_do()
	if pumvisible() || (&t_Co < 8 && !has("gui_running"))
		return
	endif

	" skip over non-syntax
	let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
				\ '=~?	"string\\|character\\|singlequote\\|escape\\|comment"'
	execute 'if' s_skip '| let s_skip = 0 | endif'

	let stopline = line('w0')

	" find innermost span, gstart-gend
	let [gstart, gend] = [[0, 0], [0, 0]]

	for pair in split(&l:matchpairs, ',')
		let [p_open, p_close] = split(pair, ':')
		let p_open = '\V' . escape(p_open, '/\')
		let p_close = '\V' . escape(p_close, '/\')
		" search backwards for opener
		let pstart = searchpairpos(p_open, '', p_close, 'bnW', s_skip, stopline, g:inner_paren_hl_searchpairpos_timeout)
		if pstart[0] >= gstart[0] && pstart[1] >= gstart[1]
			" found and nearer than previous? get matching closer
			let pend = searchpairpos(p_open, '', p_close, 'cnW', s_skip, 0, g:inner_paren_hl_searchpairpos_timeout)
			if pend[0] > 0 && pend[1] > 0
				" found, keep.
				let [gstart, gend] = [pstart, pend]
			endif
		endif
	endfor

	if gstart[0] > 0 && gstart[1] > 0
		" found, highlight
		exe '2match innerparenhlSpan /'
			\ . '\%' . gstart[0] . 'l\%' . gstart[1] . 'c'
			\ . '\_.*'
			\ . '\%' . gend[0] . 'l\%' . (gend[1] + 1) . 'c'
			\ . '/'
	else
		" nothing found, clear.
		2match none
	endif

endfunction

command! NoInnerParenHighlight windo 2match none | unlet! g:loaded_inner_paren_hl | au! inner_paren_hl
command! DoInnerParenHighlight runtime plugin/inner_paren_hl.vim | windo doau CursorMoved

let &cpo = s:cpo_save
unlet s:cpo_save
