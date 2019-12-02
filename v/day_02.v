import os

fn main() {
	input := os.read_file('../inputs/20191202.txt') or {
		println('input not found')
		return
	}
	split := input.trim_space().split(',')
	ints := split.map(it.int())
	for x := 0; x < 100; x++ {
		for y := 0; y < 100; y++ {
			mut reg := ints.clone()
			reg[1] = x
			reg[2] = y
			mut pos := 0
			for {
				val := reg[pos]
				match val {
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
					else {
						println('invalid opcode $val at pos $pos')
						return
					}
				}
				pos += 4
			}
		}
	}
}
