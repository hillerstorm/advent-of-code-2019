import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191207.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	part1 := run(parsed, [0, 1, 2, 3, 4])
	println('part 1: $part1')

	part2 := run(parsed, [5, 6, 7, 8, 9])
	println('part 2: $part2')
}

fn run(input []i64, settings []int) i64 {
	mut max := i64(0)

	for perm in helpers.permutations(settings) {
		mut vm1 := intcode.new_program(input.clone())
		mut vm1_out_idx := 0
		vm1.input(perm[0])
		vm1.input(0)

		mut vm2 := intcode.new_program(input.clone())
		mut vm2_out_idx := 0
		vm2.input(perm[1])

		mut vm3 := intcode.new_program(input.clone())
		mut vm3_out_idx := 0
		vm3.input(perm[2])

		mut vm4 := intcode.new_program(input.clone())
		mut vm4_out_idx := 0
		vm4.input(perm[3])

		mut vm5 := intcode.new_program(input.clone())
		mut vm5_out_idx := 0
		vm5.input(perm[4])

		for !vm5.done {
			vm1.run()
			for vm1_out_idx < vm1.outputs.len {
				vm2.input(vm1.outputs[vm1_out_idx++])
			}
			vm2.run()
			for vm2_out_idx < vm2.outputs.len {
				vm3.input(vm2.outputs[vm2_out_idx++])
			}
			vm3.run()
			for vm3_out_idx < vm3.outputs.len {
				vm4.input(vm3.outputs[vm3_out_idx++])
			}
			vm4.run()
			for vm4_out_idx < vm4.outputs.len {
				vm5.input(vm4.outputs[vm4_out_idx++])
			}
			vm5.run()
			for vm5_out_idx < vm5.outputs.len {
				vm1.input(vm5.outputs[vm5_out_idx++])
			}
		}

		if vm5.result > max {
			max = vm5.result
		}
	}

	return max
}
