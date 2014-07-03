" プロセスが kill されたあとに処理を hook する

let s:Reunions = vital#of("vital").import("Reunions")
let s:ruby = s:Reunions.process("ruby -e 'sleep 10;'")


" 意図的にプロセスを終了させるための関数
function! ReunionsExample_on_kill_kill()
	echo s:ruby.kill_force()
endfunction


" プロセスの監視を行うためのタスク
" これは
" "終了した瞬間"
" ではなくて
" "終了したあと"
" に s:Reunions.update_in_cursorhold(1) が呼ばれたタイミングで処理される
let s:kill_check_task = {
\	"process" : s:ruby
\}

function! s:kill_check_task.apply(parent, ...)
	" プロセスが終了したあとに処理を行う
	if s:ruby.is_killed()
		echom "Process killed"
		call a:parent.kill(self)
	endif
endfunction
call s:Reunions.register(s:kill_check_task)


augroup reunions-example
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

