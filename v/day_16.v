import (
	helpers
)

const (
	pattern = [0, 1, 0, -1]
	iterations = 100
)

fn main() {
	input := helpers.read_file('../inputs/20191216.txt')?

	mut part1_digits := helpers.split_to_ints(input, '')
	part1_middle := (part1_digits.len / 2) + 1

	for i := 0; i < iterations; i++ {
		for idx := 0; idx < part1_middle; idx++ {
			mut res := 0
			for sub_idx := idx; sub_idx < part1_digits.len; sub_idx++ {
				digit := part1_digits[sub_idx]
				mul := pattern[((sub_idx + 1) / (idx + 1)) % pattern.len]
				res += digit * mul
			}
			part1_digits[idx] = helpers.abs(res) % 10
		}
		mut sum := 0
		for idx := part1_digits.len - 1; idx >= part1_middle; idx-- {
			sum += part1_digits[idx]
			part1_digits[idx] = helpers.abs(sum) % 10
		}
	}

	part1 := helpers.join(part1_digits[..8])

	offset := input[..7].trim_left('0').int()
	// assuming offset is after middle...
	mut part2_digits := helpers.split_to_ints(input.repeat(10000)[offset..], '')

	for i := 0; i < iterations; i++ {
		mut sum := 0
		for idx := part2_digits.len - 1; idx >= 0; idx-- {
			sum += part2_digits[idx]
			part2_digits[idx] = helpers.abs(sum) % 10
		}
	}

	part2 := helpers.join(part2_digits[..8])

	println('part 1: $part1')
	println('part 2: $part2')
}
