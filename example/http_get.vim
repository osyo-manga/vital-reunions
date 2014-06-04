" 非同期で HTTP GET を行う

call vital#of("vital").unload()
let s:Reunions = vital#of("vital").import("Reunions")

" GET を行うプロセスを開始する
" GET は  curl か wget を使用して行われる
let s:process = s:Reunions.http_get("http://www.vim.org/")

" 終了時の処理
function! s:process.then(output, ...)
	" header を出力
	echom string(a:output.header)
endfunction


" GET の実行中にコマンドラインにメッセージを出力する
let s:message = {}
let s:message.process = s:process

" 毎時呼ばれる処理
function! s:message.apply(parent)
	" プロセスが終了していたら削除
	if self.process.is_exit()
		return a:parent.kill(self)
	endif
	echo "processing..."
endfunction

call s:Reunions.register(s:message)


augroup test
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

