let s:task = vital#of("vital").import("Reunions.Task")

function! s:test_task()
	let task = {
\		"count" : 0,
\	}
	function! task.apply(...)
		let self.count += 1
	endfunction
	call s:task.register(task)
	call s:task.update()
	call s:task.update()
	call s:task.update()
	Assert task.count == 3
endfunction


