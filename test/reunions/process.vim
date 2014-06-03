
call vital#of("vital").unload()
let s:Base = vital#of("vital").import("Reunions.Process.Base")
let s:Interactive = vital#of("vital").import("Reunions.Process.Interactive")
let s:Process = vital#of("vital").import("Reunions.Process")
let s:TaskGroup = vital#of("vital").import("Reunions.Task.Group")


function! s:test_as_task()
	let tasks = s:TaskGroup.make()
	let ruby = s:Base.make("ruby")
	call ruby.start("-e 'print 42'")
	let id = tasks.register(s:Process.as_task(ruby))
	Assert has_key(ruby, "apply")
	Assert tasks.size() == 1
	call tasks.update()
	Assert tasks.size() == 1
	call ruby.kill()
	call tasks.update()
	Assert tasks.size() == 1
	Assert ruby.kill(1) == 0
	Assert tasks.size() == 1
	call tasks.update()
	Assert tasks.size() == 1
	call tasks.kill(ruby)
	Assert tasks.size() == 0
endfunction


function! s:test_as_autokill_task()
	let tasks = s:TaskGroup.make()
	let ruby = s:Base.make("ruby")
	call tasks.register(s:Process.as_autokill_task(ruby))
	Assert has_key(ruby, "apply")
	call tasks.update()
	call tasks.update()
	Assert tasks.size() == 1
	call ruby.start("-e 'print 42'")
	Assert tasks.size() == 1
	call ruby.wait()
	Assert tasks.size() == 1
	call tasks.update()
	Assert tasks.size() == 0
endfunction


function! s:test_as_autokill_task_in_interactive()
	let tasks = s:TaskGroup.make()
	let irb = s:Interactive.make("irb --simple-prompt", '\n>>\s$')
	call tasks.register(s:Process.as_autokill_task(irb))
	Assert has_key(irb, "apply")
	call tasks.update()
	Assert tasks.size() == 1
	call irb.start()
	call tasks.update()
	Assert tasks.size() == 1
	call irb.wait()
	Assert tasks.size() == 1
	call irb.input("sleep 1")
	call irb.wait()
	call tasks.update()
	Assert tasks.size() == 1

	call irb.input("exit")
	call irb.wait()
	Assert tasks.size() == 1
	call tasks.update()
	call irb.wait()
	Assert tasks.size() == 0
endfunction


