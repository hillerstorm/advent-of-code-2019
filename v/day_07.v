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
		mut vm1 := &intcode.Program {
			memory: input.clone()
			input_source: &intcode.Program{outputs:[perm[0], 0]}
			outputs: [perm[1]]
		}
		vm1.run()

		mut vm2 := &intcode.Program {
			memory: input.clone()
			input_source: vm1
			outputs: [perm[2]]
		}
		vm2.run()

		mut vm3 := &intcode.Program {
			memory: input.clone()
			input_source: vm2
			outputs: [perm[3]]
		}
		vm3.run()

		mut vm4 := &intcode.Program {
			memory: input.clone()
			input_source: vm3
			outputs: [perm[4]]
		}
		vm4.run()

		mut vm5 := &intcode.Program {
			memory: input.clone()
			input_source: vm4
			outputs: vm1.input_source.outputs
		}
		vm1.input_source = vm5
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
