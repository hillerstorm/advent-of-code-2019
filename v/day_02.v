import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191202.txt')?
	mut parsed := helpers.split_to_i64s(input, ',')

	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			parsed[1] = noun
			parsed[2] = verb

			inputs := []i64
			outputs := []i64
			mut vm := &intcode.Program {
				memory: parsed.clone()
				inputs: &inputs
				outputs: &outputs
			}
			vm.run()

			if noun == 12 && verb == 2 {
				println('part 1: $vm.result')
			} else if vm.result == 19690720 {
				println('part 2: ${100 * noun + verb}')
			}
		}
	}
}
