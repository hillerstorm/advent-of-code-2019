import (
	helpers
	intcode
	readline
)

fn main() {
	input := helpers.read_file('../inputs/20191225.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut out_idx := 0
	mut vm := intcode.new_program(parsed.clone())
	vm.run()
	for !vm.done {
		vm.run()
		for out_idx < vm.outputs.len {
			print(string([byte(vm.outputs[out_idx++])]))
		}
		if vm.done {
			break
		}
		mut line := ''
		for line == '' {
			ln := readline.read_line('> ') or {
				''
			}
			line = ln
		}
		line = line.trim_space() + '\n'
		for chr in line.bytes() {
			vm.input(i64(chr))
		}
	}
}
