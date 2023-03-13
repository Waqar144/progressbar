module statusbar

import time

fn printchar(s byte) {
	if isnil(s) {
		panic('printchar(NIL)')
	}
	eprint('${s.ascii_str()}')
	return
}

struct Statusbar {
mut:
	label string
	format_length int
	format []rune
	finished bool
}

pub fn new_statusbar(label string) &Statusbar {
	format := [`-`,`\\`,`|`,`/`]
	return &Statusbar{
		label: label
		format_length: format.len
		format: format
	}
}


pub fn new_statusbar_with_format(_label string, _format []rune) &Statusbar {
	return &Statusbar{
		label: _label
		format_length: _format.len
		format: _format
	}
}

pub fn (s &Statusbar) start(){
	for i := 0; i <=s.format_length; i++ {
		if i == s.format_length {
			i = 0
		}

		printchar(`\r`)
		eprint(s.label + ' ' + s.format[i].str())
		if s.finished {
			break
		}

		time.sleep(10000 * time.microsecond)
	}
}

pub fn (mut s Statusbar) finish() {
	s.finished = true
	printchar(`\r`)
	println(s.label + ' ' + s.format[0].str())
}

// fn main(){
// 	fmt := [`1`,`2`, `3`, `.`]
// 	mut s := new_statusbar_with_format('Loading', fmt)
// 	go s.start()
// 	time.sleep(2)
// 	do your stuff here
// 	s.finish()
// }
