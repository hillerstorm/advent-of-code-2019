import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191202.txt')?
	mut parsed := helpers.split_to_ints(input, ',')

	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			parsed[1] = noun
			parsed[2] = verb
			result := intcode.run(parsed, [])

			if noun == 12 && verb == 2 {
				println('part 1: $result')
			} else if result == 19690720 {
				println('part 2: ${100 * noun + verb}')
			}
		}
	}
}
