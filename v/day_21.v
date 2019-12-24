import (
	helpers
	intcode
)

fn main() {
	input := helpers.read_file('../inputs/20191221.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	p1_input := [
		'NOT C T',
		'AND D T',
		'NOT A J',
		'OR T J',
		'WALK',
		''
	].join('\n').bytes()
	mut vm1 := intcode.new_program(parsed.clone())
	vm1.run()
	mut out_idx := 0
	for out_idx < vm1.outputs.len {
		print(string([byte(vm1.outputs[out_idx++])]))
	}
	for cmd in p1_input {
		vm1.input(i64(cmd))
		print(string([cmd]))
	}
	vm1.run()
	for out_idx < vm1.outputs.len {
		print(string([byte(vm1.outputs[out_idx++])]))
	}

	p2_input := [
		'NOT A J',
		'NOT B T',
		'OR T J',
		'NOT C T',
		'OR T J',
		'OR T T',
		'AND D J',
		'AND E T',
		'OR H T',
		'AND T J',
		'RUN',
		''
	].join('\n').bytes()
	mut vm2 := intcode.new_program(parsed.clone())
	vm2.run()
	out_idx = 0
	for out_idx < vm2.outputs.len {
		print(string([byte(vm2.outputs[out_idx++])]))
	}
	for cmd in p2_input {
		vm2.input(i64(cmd))
		print(string([cmd]))
	}
	vm2.run()
	for out_idx < vm2.outputs.len - 1{
		print(string([byte(vm2.outputs[out_idx++])]))
	}

	if vm1.result != 10 {
		println('part 1: $vm1.result')
	}
	if vm2.result != 10 {
		println('part 2: $vm2.result')
	}
}
