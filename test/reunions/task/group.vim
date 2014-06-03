
let s:task_group = vital#of("vital").import("Reunions.Task.Group")

function! s:test_group()
	let group = s:task_group.make()

	call group.update()
	call group.update()
	Assert group.log() == ""
endfunction


function! s:test_register()
	let task = {
\		"count" : 0
\	}
	function! task.apply(...)
		let self.count += 1
	endfunction

	let group = s:task_group.make()

	call group.register(task)
	call group.register(task)
	let task2 = group.register(deepcopy(task))

	Assert group.size() == 3
	call group.update()
	call group.update()
	call group.update()

	Assert task.count == 6
	Assert task2.count == 3
	Assert group.log() == ""
endfunction



let s:count = 0
function! s:func(...)
	let s:count += 1
endfunction


function! s:test_register_func()
	let group = s:task_group.make()

	let task = group.register(function("s:func"))

	call group.update()
	call group.update()
	call group.update()
	call group.kill(task)
	call group.update()
	call group.update()
	call group.update()

	let cnt = s:count
	Assert cnt == 3
	Assert group.log() == ""
endfunction


function! s:test_register_after_apply()
	let group = s:task_group.make()

	let task = group.register({})
	let task.count = 0
	function! task.apply(parent, ...)
		let self.count += 1
		if self.count >= 3
			call a:parent.kill(self)
		endif
	endfunction

	call group.update()
	call group.update()
	call group.update()
	call group.update()
	call group.update()
	call group.update()

	Assert task.count == 3
	Assert group.log() == ""
endfunction


function! s:test_kill()
	let task = {
\		"count" : 0
\	}
	function! task.apply(...)
		let self.count += 1
	endfunction

	let group = s:task_group.make()

	call group.register(task)
	call group.update()
	call group.update()
	call group.update()
	Assert group.kill({}) == -1
	Assert group.kill(task) == 0
	Assert group.kill({}) == -1
	call group.update()
	call group.update()
	call group.update()

	Assert task.count == 3
	Assert group.log() == ""
endfunction



function! s:test_kill_self()
	let task = {
\		"count" : 0
\	}
	function! task.apply(parent, ...)
		let self.count += 1
		if self.count >= 3
			call a:parent.kill(self)
		endif
	endfunction

	let group = s:task_group.make()

	call group.register(task)
	call group.update()
	call group.update()
	call group.update()
	call group.update()
	call group.update()
	call group.update()

	Assert task.count == 3
	Assert group.log() == ""
endfunction


function! s:test___reunions_task_apply()
	let task = {
\		"count" : 0
\	}

	function! task.apply(...)
		let self.count += 1
	endfunction
	function! task.__reunions_task_apply(...)
		let self.count -= 1
	endfunction

	let group = s:task_group.make()

	call group.register(task)
	call group.update()
	call group.update()
	call group.update()

	Assert task.count == -3

endfunction


function! s:test_kill_all()
	let task = {
\		"count" : 0
\	}
	function! task.apply(...)
		let self.count += 1
	endfunction

	let group = s:task_group.make()

	call group.register(task)
	call group.register(task)
	call group.register(task)
	Assert len(group.list()) == 3
	call group.update()
	call group.update()
	call group.update()
	call group.kill_all()
	Assert len(group.list()) == 0
	
	Assert task.count == 9
	Assert group.log() == ""
endfunction


