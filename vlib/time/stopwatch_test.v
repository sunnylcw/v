import time

// NB: on CI jobs, especially msvc ones, sleep_ms may sleep for much more
// time than you have specified. To avoid false positives from CI test
// failures, some of the asserts will be run only if you pass `-d stopwatch`
fn test_stopwatch_works_as_intended() {
	mut sw := time.new_stopwatch({})
	// sample code that you want to measure:
	println('Hello world')
	time.sleep_ms(1)
	//
	println('Greeting the world took: ${sw.elapsed().nanoseconds()}ns')
	assert sw.elapsed().nanoseconds() > 0
}

fn test_stopwatch_time_between_pause_and_start_should_be_skipped_in_elapsed() {
	println('Testing pause function')
	mut sw := time.new_stopwatch({})
	time.sleep_ms(10) // A
	eprintln('Elapsed after 10ms nap: ${sw.elapsed().milliseconds()}ms')
	assert sw.elapsed().milliseconds() >= 10
	sw.pause()
	time.sleep_ms(10)
	eprintln('Elapsed after pause and another 10ms nap: ${sw.elapsed().milliseconds()}ms')
	assert sw.elapsed().milliseconds() >= 10
	$if stopwatch ? {
		assert sw.elapsed().milliseconds() < 20
	}
	sw.start()
	time.sleep_ms(10) // B
	eprintln('Elapsed after resume and another 10ms nap: ${sw.elapsed().milliseconds()}ms')
	assert sw.elapsed().milliseconds() >= 20
	$if stopwatch ? {
		assert sw.elapsed().milliseconds() < 30
	}
}
