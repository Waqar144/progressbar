import statusbar
import progressbar
import time

fn main() {
	mut p := progressbar.Progressbar{}
	p.new('Smooth', 60)
	for i := 0; i < 60; i++ {
		time.sleep(100000 * time.microsecond)
		p.increment()
	}
	p.finish()

	mut p1 := progressbar.Progressbar{}
	p1.new_with_format('Waqar', 60, [`|`, `-`, `|`])
	for i := 0; i < 60; i++ {
		time.sleep(100000 * time.microsecond)
		p1.increment()
	}
	p1.finish()

	mut s := statusbar.new_statusbar('Exiting')
	spawn s.start()
	time.sleep(3 * time.second)
	s.finish()
}
