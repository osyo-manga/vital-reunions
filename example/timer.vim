" n 秒毎に処理を呼び出す

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
" 2.0 秒毎に apply が呼ばれる
" NOTE: の値はあくまでも目安なので必ず 2.0 秒毎とは限らないことに注意
" これは 'updatetime' に設定されている時間より短いと正しく動作しません
call s:Reunions.timer(s:task, 2.0)


augroup reunions-example-timer
	autocmd!
	" プロセスの更新を行うための関数
	" 任意のタイミングで定期的に呼び出す必要がある
	" このタイミングで s:task.apply が呼び出される
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

