" 任意の処理を定期的に実行する

let s:Reunions = vital#of("vital").import("Reunions")

" 定期処理を行うためのタスクを生成
let s:task = {
\	"count" : 0
\}

" 定期的に呼び出される関数
" 第一引数には登録されている親が渡される
function! s:task.apply(parent, ...)
	let self.count += 1
	echo self.count

	" 10回処理が呼ばれたら自分の登録を削除する
	if self.count >= 10
		call a:parent.kill(self)
	endif
endfunction

" タスクを登録する
call s:Reunions.register(s:task)


augroup reunions-example
	autocmd!
	" プロセスの更新を行うための関数
	" 任意のタイミングで定期的に呼び出す必要がある
	" このタイミングで s:task.apply が呼び出される
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

