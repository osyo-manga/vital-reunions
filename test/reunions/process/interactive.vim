call vital#of("vital").unload()
let s:Interactive = vital#of("vital").import("Reunions.Process.Interactive")
let s:Process = vital#of("vital").import("Reunions.Process")
let s:TaskGroup = vital#of("vital").import("Reunions.Task.Group")


function! s:test_interactive()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	Assert irb.status() == "none"
	call irb.start()
	Assert irb.status() == "processing"
	call irb.wait()
	Assert irb.status() == "waiting"
	Assert irb.is_exit()
	call irb.input("1 + 2")
	Assert irb.get() =~# "1 + 2\n=> 3\n>>"

	call irb.input("3 + 2")
	Assert irb.get() =~# "3 + 2\n=> 5\n>>"

	Assert irb.kill(1) == 0
endfunction


function! s:test_status()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	Assert irb.status() == "none"
	call irb.start()
	Assert irb.status() == "processing"
	call irb.wait()
	Assert irb.status() == "waiting"
	call irb.input("sleep 1")
	Assert irb.status() == "processing"
	call irb.wait()
	Assert irb.status() == "waiting"
	call irb.input("sleep 1")
	Assert irb.status() == "processing"
	call irb.wait()
	Assert irb.kill(1) == 0
	Assert irb.status() == "success"
	call irb.start()
	Assert irb.status() == "processing"
	call irb.wait()
	Assert irb.status() == "waiting"
	call irb.input("sleep 1")
	Assert irb.status() == "processing"
	Assert irb.kill() == -1
	Assert irb.status() == "processing"
	Assert irb.kill(1) == 0
	Assert irb.status() == "kill"
endfunction


function! s:test_input()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	call irb.start()
	Assert irb.input("1 + 2") == -1
	call irb.wait()
	Assert irb.input("sleep 1") == 0
	Assert irb.input("sleep 1") == -1
	call irb.wait()
	Assert irb.input("1 + 2") == 0

	Assert irb.kill(1) == 0
endfunction


function! s:test_then()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')

	function! irb.then(output, ...)
		let self.output = a:output
	endfunction
	call irb.start()
	call irb.wait()

	call irb.input("1 + 2")
	call irb.wait()
	Assert irb.output =~# "1 + 2\n=> 3\n>>"

	Assert irb.kill(1) == 0
endfunction


function! s:test_group()
	let group = s:TaskGroup.make()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	call group.register(s:Process.as_task(irb))

	function! irb.then(output, ...)
		let self.output = a:output
	endfunction

	call group.register(s:Process.as_task(irb))

	call irb.start()
	call irb.wait()

	call irb.input("1 + 2")
	sleep 300ms
	call group.update()
	Assert irb.output =~# "1 + 2\n=> 3\n>>"

	Assert irb.kill(1) == 0
endfunction


function! s:test_exit()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	call irb.start()
	call irb.wait()

	call irb.input("exit")
	call irb.wait()
	Assert irb.status() == "success"

	Assert irb.kill(1) == 0
endfunction



