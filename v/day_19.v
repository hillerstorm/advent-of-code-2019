import (
	helpers
	intcode
)

fn main() {
	input := helpers.read_file('../inputs/20191219.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut part1 := i64(0)
	for y := 0; y < 50; y++ {
		for x := 0; x < 50; x++ {
			part1 += get_state(x, y, &parsed)
		}
	}
	println('part 1: $part1')

	mut part2 := 0
	mut x_start := 0
	for y := 600; y < 700; y++ {
		mut prev_was_active := false
		for x := 1400; x < 1500; x++ {
			top_left := get_state(x, y, &parsed) == 1
			if top_left && !prev_was_active {
				x_start = x - 1
				prev_was_active = true
			} else if !top_left {
				if prev_was_active {
					break
				}
				continue
			}
			if get_state(x, y + 99, &parsed) == 1 {
				if get_state(x + 99, y, &parsed) == 1 {
					part2 = x * 10000 + y
					y = 2000
					break
				}
			}
		}
	}
	println('part 2: $part2')
}

fn get_state(x, y int, memory []i64) i64 {
	mut vm := intcode.new_program(memory.clone())
	vm.input(x)
	vm.input(y)
	vm.run()

	return vm.result
}
