import (
	os
	helpers
	intcode
)

fn main() {
	input := os.read_file('../inputs/20191205.txt')?
	parsed := helpers.split_to_ints(input, ',')

	part_1 := intcode.run(parsed, [1])
	part_2 := intcode.run(parsed, [5])

	println('part 1: $part_1')
	println('part 2: $part_2')
}
