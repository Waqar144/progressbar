module statusbar

import time

fn printchar(s byte) {
	if isnil(s) {
		panic('printchar(NIL)')
	}
	C.fputc(s, stdout)
	C.fflush(stdout)
	return
}

struct Statusbar {
mut:
	label string
	format_length int
	format []byte
	finished bool
}

pub fn new_statusbar(label string) &Statusbar {
	format := [`-`,`\\`,`|`,`/`]
	return &Statusbar{label: label, format_length: format.len, format: format}
}


pub fn new_statusbar_with_format(_label string, _format []byte) &Statusbar {
	return &Statusbar{label: _label, format_length: _format.len, format: _format}
}

pub fn (s &Statusbar) start(){
	for i := 0; i <=s.format_length; i++ {
		if i == s.format_length {
			i = 0
		}

		printchar(`\r`)
		print(s.label + ' ' + s.format[i].str())
		if(s.finished){
			break
		}

		time.usleep(10000)
	}
}

pub fn (s mut Statusbar) finish() {
	printchar(`\r`)
	s.finished = true
}

// fn main(){
// 	fmt := [`1`,`2`, `3`, `.`]
// 	mut s := new_statusbar_with_format('Loading', fmt)
// 	go s.start()
// 	time.sleep(2)
// 	do your stuff here
// 	s.finish()
// }
