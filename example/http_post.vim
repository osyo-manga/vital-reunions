" 非同期で HTTP POST を行う

call vital#of("vital").unload()
let s:V = vital#of("vital")
let s:Reunions = s:V.import("Reunions")
let s:JSON = s:V.import("Web.JSON")

" POST を行うプロセスを開始する
" POST は curl か wget を使用して行われる
let s:process = s:Reunions.http_post("http://vim-help-jp.herokuapp.com/search", { "in": "indent" })

" 終了時の処理
function! s:process.then(output, ...)
	echom string(s:JSON.decode(a:output.content))
endfunction


" POST の実行中にコマンドラインにメッセージを出力する
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


augroup reunions-example
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END

