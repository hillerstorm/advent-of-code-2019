import (
	os
)

enum typ {
	deal
	increment
	cut
}

struct Instruction {
	typ typ
	value int
}

fn main() {
	input := os.read_lines('../inputs/20191222.txt')?
	instructions := parse_instructions(input)

	part1 := get_part_1(10007, 2019, instructions)
	println('part 1: $part1')
}

fn get_part_1(deck_len, start_idx i64, instructions []Instruction) i64 {
	mut idx := start_idx

	for instruction in instructions {
		match instruction.typ {
			.deal {
				idx = deck_len - idx - 1
			}
			.increment {
				idx = (idx * instruction.value) % deck_len
			}
			.cut {
				idx = (idx - instruction.value) % deck_len
				if idx < 0 {
					idx = deck_len + idx
				}
			}
			else {}
		}
	}

	return idx
}

fn parse_instruction(line string) Instruction {
	parts := line.split(' ')[1..]
	return match parts[0] {
		'into' {
			&Instruction{typ.deal, 0}
		}
		'with' {
			&Instruction{typ.increment, parts[2].int()}
		}
		else {
			&Instruction{typ.cut, parts[0].int()}
		}
	}
}

fn parse_instructions(lines []string) []Instruction {
	return lines.map(parse_instruction(it))
}
