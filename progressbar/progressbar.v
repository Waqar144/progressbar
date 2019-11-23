module progressbar

import time

#include<sys/ioctl.h>

struct Winsize {
  ws_row u16
  ws_col u16
  ws_xpixel u16
  ws_ypixel u16
}

fn difftime(b time.Time) int {
	temp := time.now()
	offset := ((temp.minute - b.minute) * 60 ) + (temp.second - b.second)
	return offset
}

fn get_screen_width() int {
	ws := Winsize{}
	cols := if C.ioctl(1, C.TIOCGWINSZ, &ws) == -1 { 80 } else { int(ws.ws_col) }
	return cols
}

fn printchar(s byte) {
	if isnil(s) {
		panic('printchar(NIL)')
	}
	C.fputc(s, stdout)
	C.fflush(stdout)
	return
}

const (
	DEFAULT_SCREEN_WIDTH = 80
	MIN_BAR_WIDTH = 10
	WHITESPACE_LENGTH = 2
	BAR_BORDER_WIDTH = 2
	ETA_FORMAT_LENGTH = 13
)

pub struct Progressbar {
mut:
	max u64
	value u64

	start time.Time
	label string

	begin byte
	fill byte
	end byte
}

struct ProgressbarTime {
	hours int
	min int
	sec int
}

pub fn (p mut Progressbar) new_with_format (label string, max u64, format []byte) {
	p.max = max
	p.value = 0
	p.label = label
	p.start = time.now()

	p.begin = format[0]
	p.fill = format[1]
	p.end = format[2]
}

pub fn (p mut Progressbar) new (label string, max u64) {
	p.new_with_format(label, max, [`|`, `=`, `|`])
}

fn (p mut Progressbar) update(value u64) {
	p.value = value
	p.draw()
}

fn (p mut Progressbar) update_label(label string) {
	p.label = label
}

pub fn (p mut Progressbar) increment() {
	p.update(p.value + u64(1))
}

fn (p Progressbar) write_char(ch byte, times int) {
	for i := 0; i < times; i++ {
        printchar(ch)
	}
}

fn max (a int , b int) int {
	if a > b {
		return a
	} else {
		return b
	}
}

fn progressbar_width(screen_width int, label_len int) int {
	return max(MIN_BAR_WIDTH, screen_width - label_len - ETA_FORMAT_LENGTH - WHITESPACE_LENGTH)
}

fn progressbar_label_width (screen_width int, label_len int, bar_width int) int {
	if label_len + 1 + bar_width + ETA_FORMAT_LENGTH > screen_width {
		return max(0, screen_width - bar_width - ETA_FORMAT_LENGTH - WHITESPACE_LENGTH)
	}
	else {
		return label_len
	}
}



fn (p Progressbar) remaining_seconds() int {

	offset := difftime(p.start)
	if (p.value > 0) && (offset > 0) {
		return int ( (f64(offset) / f64(p.value)) * (int(p.max) - int(p.value)) )
	} else {
		return 0
	}
}

fn calc_time_components (secs int) ProgressbarTime {
	mut seconds := secs
	hours := seconds / 3600
	seconds -= hours * 3600
	mins := seconds / 60
	seconds -= mins * 60

	components := ProgressbarTime{hours, mins, seconds}
	return components
}

fn (p Progressbar) draw() {
	//clear the line
	C.printf("%c[2K", 27)
	screen_width := get_screen_width()
	label_len := p.label.len
	mut bar_width := progressbar_width(screen_width, label_len)
	label_width := progressbar_label_width(screen_width, label_len, bar_width)

	completed := if p.value >= p.max {
		true
	} else {
		false
	}

	x := f64(p.value) / f64(p.max)
	bar_piece_count := bar_width - BAR_BORDER_WIDTH
	bar_piece_current := if completed {
		bar_piece_count
	} else {
		int(f64(bar_piece_count) * x)
	}

	offset := difftime(p.start)
	eta := if completed {
		calc_time_components(offset)
	} else {
		calc_time_components(p.remaining_seconds())
	}

	if label_width == 0 {
		bar_width += 1
	} else {
        print(p.label)
		printchar(` `)
	}

	printchar(p.begin)
	p.write_char(p.fill, bar_piece_current)
	p.write_char(` `, bar_piece_count - bar_piece_current)
	printchar(p.end)

	printchar(` `)
	eta_format := 'ETA:$eta.hours\h$eta.min\m$eta.sec\s'
	print(eta_format)
	printchar(`\r`)
}

pub fn (p Progressbar) finish() {
	p.draw()
	println('')
}
