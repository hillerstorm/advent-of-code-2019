import os

fn main() {
	input := os.read_file('../inputs/20191202.txt')?

	split := input.trim_space().split(',')
	ints := split.map(it.int())
	for x := 0; x < 100; x++ {
		for y := 0; y < 100; y++ {
			mut reg := ints.clone()
			reg[1] = x
			reg[2] = y
			for pos := 0; pos < reg.len; pos += 4 {
				match reg[pos] {
					1 {
						reg[reg[pos + 3]] = reg[reg[pos + 1]] + reg[reg[pos + 2]]
					}
					2 {
						reg[reg[pos + 3]] = reg[reg[pos + 1]] * reg[reg[pos + 2]]
					}
					99 {
						if x == 12 && y == 2 {
							println('part1: ${reg[0]}')
						} else if reg[0] == 19690720 {
							println('part2: ${100 * x + y}')
						}
						break
					}
				}
			}
		}
	}
}
