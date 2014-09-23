
call vital#of("vital").unload()
let s:Base = vital#of("vital").import("Reunions.Process.Base")
" let s:Process = vital#of("vital").import("Reunions.Process.Process")
let s:TaskGroup = vital#of("vital").import("Reunions.Task.Group")



function! s:test_process()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'print 42'")
	sleep 1
	Assert !ruby.is_exit()
	Assert ruby.is_alive()
	call ruby.wait()
	Assert ruby.as_result().body == "42"
	Assert ruby.as_result().status == "success"
	let result = ruby.get()
	Assert result == "42"
endfunction


function! s:test_status()
	let ruby = s:Base.make("ruby")
	Assert ruby.status() == "none"
	call ruby.start("-e 'sleep 1; print 42'")
	Assert ruby.update() == "processing"
	Assert ruby.status() == "processing"
	let result =  ruby.get()
	Assert ruby.status() == "success"
	Assert result == "42"

	call ruby.start("-e 'sleep 1; print 42'")
	Assert ruby.status() == "processing"
	let result =  ruby.get()
	Assert ruby.status() == "success"
	Assert result == "42"
endfunction


function! s:test_status_failure()
	let ruby = s:Base.make("ruby")
	Assert ruby.status() == "none"
	call ruby.start("-e 'sleep 1 print 42'")
	Assert ruby.status() == "processing"
	call ruby.wait()
	Assert ruby.status() == "failure"
" 	Assert result == "42"
endfunction


function! s:test_then()
	let ruby = s:Base.make("ruby")
	function! ruby.then(result, ...)
		let self.result = a:result
	endfunction
	call ruby.start("-e 'print 42'")
	call ruby.wait()
	Assert ruby.result == "42"
endfunction


function! s:test_then2()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'print 42'")
	sleep 1
	function! ruby.then(result, ...)
		let self.result = a:result
	endfunction
	call ruby.wait()
	Assert ruby.result == "42"
endfunction


function! s:test_kill()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e '$stdout.sync = true; print 42; sleep 1; print 30'")
	call ruby.kill()
	Assert ruby.status() == "processing"
	call ruby.kill(1)
	Assert ruby.status() == "kill"
endfunction


function! s:test_is_killed()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e '$stdout.sync = true; print 42; sleep 1; print 30'")
	Assert !ruby.is_killed()
	call ruby.kill()
	Assert !ruby.is_killed()
	call ruby.kill(1)
	Assert ruby.is_killed()

	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'print 42'")
	call ruby.wait()
	Assert ruby.is_killed()

	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'pri 42'")
	call ruby.wait()
	Assert ruby.is_killed()
	Assert ruby.status() == 'failure'
endfunction


function! s:test_wait_for()
	let ruby = s:Base.make("ruby")
	Assert ruby.status() == "none"
	call ruby.start("-e '$stdout.sync = true; print 42; sleep 1; print 30'")
	Assert ruby.status() == "processing"
	call ruby.wait_for(0.5)
	Assert ruby.status() == "processing"
	call ruby.kill(1)
	Assert ruby.status() == "kill"
	Assert ruby.as_result().body == "42"
" 	Assert ruby.status() == "failure"
endfunction


function! s:test_kill_force()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'sleep 1; print 42'")
	call ruby.kill_force()
	Assert ruby.is_killed()
endfunction


