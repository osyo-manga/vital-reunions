" 対話型で処理を行う

let s:Reunions = vital#of("vital").import("Reunions")


" すでに存在していたら削除
if exists("s:irb")
	call s:irb.kill(1)
endif


" 対話するプロセスを起動する
let s:irb = s:Reunions.interactive("irb --simple-prompt", '\n>>\s$')
" 最初にプロセスが起動するまで待つ
call s:irb.wait()


" 対話型プロセスに対して入力を行う
" e.g.
" :call ReunionsEval("1 + 2")
function! ReunionsEval(expr)
	" 前回、入力した処理が終了するまで待つ
	call s:irb.wait()
	return s:irb.input(a:expr)
endfunction


" ReunionsEval() に渡した式を実行し終わったら呼ばれる
function! s:irb.then(output, ...)
	echom a:output
	echom matchstr(a:output, '\n\=>\s\zs.\{-}\ze\n>>\s$')
endfunction


augroup test
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

