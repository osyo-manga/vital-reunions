" スリープソート

let s:Reunions = vital#of("vital").import("Reunions")

function! s:sort(list)
	for item in a:list
		" 各要素秒を sleep する外部プロセスを立ち上げる
		let sleep = s:Reunions.process(printf(
\			"ruby -e 'sleep %d; print %d'"
\		, item + 2, item))
		" 終了したら結果を出力
		function! sleep.then(output, ...)
			echo a:output
		endfunction
	endfor
endfunction

call s:sort([5, 1, 4, 9, 3, 7, 2, 8, 0, 6])

augroup reunions-example
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

