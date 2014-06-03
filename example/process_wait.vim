" プロセスが終了するまで待ち処理を行う

let s:Reunions = vital#of("vital").import("Reunions")

" 非同期でプロセスを実行
let s:ruby = s:Reunions.process("ruby -e 'sleep 2; print 42'")

" プロセスの実行結果を取得する
" プロセスが終了するまで待ち処理が行われる
echo s:ruby.get()
" => 42

