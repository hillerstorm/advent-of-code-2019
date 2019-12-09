import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191205.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut vm1 := &intcode.Program {
		memory: parsed.clone()
		input_source: &intcode.Program{outputs: [i64(1)]}
	}
	vm1.run()

	mut vm2 := &intcode.Program {
		memory: parsed.clone()
		input_source: &intcode.Program{outputs: [i64(5)]}
	}
	vm2.run()

	println('part 1: $vm1.result')
	println('part 2: $vm2.result')
}
