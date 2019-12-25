import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191209.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut vm1 := intcode.new_program(parsed.clone())
	vm1.input(1)
	vm1.run()
	println('part 1: $vm1.result')

	mut vm2 := intcode.new_program(parsed.clone())
	vm2.input(2)
	vm2.run()
	println('part 2: $vm2.result')
}
