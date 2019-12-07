import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191205.txt')?
	parsed := helpers.split_to_ints(input, ',')

	mut vm1 := &intcode.Program {
		memory: parsed.clone()
		input_source: &intcode.Program{outputs: [1]}
	}
	vm1.run()
	part_1 := vm1.result

	mut vm2 := &intcode.Program {
		memory: parsed.clone()
		input_source: &intcode.Program{outputs: [5]}
	}
	vm2.run()
	part_2 := vm2.result

	println('part 1: $part_1')
	println('part 2: $part_2')
}
