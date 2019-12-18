import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191205.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	vm1_inputs := [i64(1)]
	vm1_outputs := []i64
	mut vm1 := &intcode.Program {
		memory: parsed.clone()
		inputs: &vm1_inputs
		outputs: &vm1_outputs
	}
	vm1.run()

	vm2_inputs := [i64(5)]
	vm2_outputs := []i64
	mut vm2 := &intcode.Program {
		memory: parsed.clone()
		inputs: &vm2_inputs
		outputs: &vm2_outputs
	}
	vm2.run()

	println('part 1: $vm1.result')
	println('part 2: $vm2.result')
}
