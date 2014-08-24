" Example minimal quickrun.vim
let s:Reunions = vital#of("vital").import("Reunions")
 
" Async run
" !{&filetype} {current file}
command! ReunionsExampleQuickRun call s:run()
 
function! s:run()
	let file = bufname("%")
	if !filereadable(file)
		echo "Not file readable."
		return
	endif
	let command = &filetype
	if !executable(command)
		echo "No found command " . command
		return
	endif
	let process = s:Reunions.process("ruby " . file)
	function! process.then(result, ...)
		execute self.winnr . "wincmd w"
		call append(line("$"), split(a:result, "\n"))
	endfunction
	new
	let process.winnr = winbufnr(".")
endfunction
 
augroup test-reunions-example-quickrun
	autocmd!
	autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
augroup END
