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

	for p in helpers.permutations(settings) {
		perm := p.map(i64(it))

		vm1_inputs := [perm[0], 0]
		vm1_outputs := [perm[1]]
		mut vm1 := &intcode.Program {
			memory: input.clone()
			inputs: &vm1_inputs
			outputs: &vm1_outputs
		}
		vm1.run()

		vm2_outputs := [perm[2]]
		mut vm2 := &intcode.Program {
			memory: input.clone()
			inputs: &vm1_outputs
			outputs: &vm2_outputs
		}
		vm2.run()

		vm3_outputs := [perm[3]]
		mut vm3 := &intcode.Program {
			memory: input.clone()
			inputs: &vm2_outputs
			outputs: &vm3_outputs
		}
		vm3.run()

		vm4_outputs := [perm[4]]
		mut vm4 := &intcode.Program {
			memory: input.clone()
			inputs: &vm3_outputs
			outputs: &vm4_outputs
		}
		vm4.run()

		mut vm5 := &intcode.Program {
			memory: input.clone()
			inputs: &vm4_outputs
			outputs: &vm1_inputs
		}
		vm5.run()

		for !vm5.done {
			vm1.run()
			vm2.run()
			vm3.run()
			vm4.run()
			vm5.run()
		}

		if vm5.result > max {
			max = vm5.result
		}
	}

	return max
}
