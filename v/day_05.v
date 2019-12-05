import os

fn main() {
	input := os.read_file('../inputs/20191205.txt')?
	split := input.trim_space().split(',')
	part_1 := run(split, 1)
	part_2 := run(split, 5)
	println('part 1: $part_1')
	println('part 2: $part_2')
}

fn run(instructions []string, input int) string {
	mut reg := instructions.map(it.int())
	mut output := ''
	mut pos := 0
	for pos < reg.len {
		mut val := reg[pos].str()
		for val.len < 5 {
			val = '0$val'
		}
		param_modes := [
			val[2..3].int(),
			val[1..2].int(),
			val[0..1].int()
		]
		match val[3..] {
			'01' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				reg[reg[pos + 3]] = first + second
				pos += 4
			}
			'02' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				reg[reg[pos + 3]] = first * second
				pos += 4
			}
			'03' {
				reg[reg[pos + 1]] = input
				pos += 2
			}
			'04' {
				first := get_param(reg, param_modes[0], pos)
				output += first.str()
				pos += 2
			}
			'05' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				pos = if first != 0 {
					second
				} else {
					pos + 3
				}
			}
			'06' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				pos = if first == 0 {
					second
				} else {
					pos + 3
				}
			}
			'07' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				reg[reg[pos + 3]] = if first < second {
					1
				} else {
					0
				}
				pos += 4
			}
			'08' {
				first, second := get_two_params(reg, param_modes[0], param_modes[1], pos)
				reg[reg[pos + 3]] = if first == second {
					1
				} else {
					0
				}
				pos += 4
			}
			'99' {
				break
			}
		}
	}

	return output.trim_left('0')
}

fn get_param(reg []int, param_mode, pos int) int {
	return match param_mode {
		0 { reg[reg[pos + 1]] }
		1 { reg[pos + 1] }
		else {0}
	}
}

fn get_two_params(reg []int, param_mode_1, param_mode_2, pos int) (int, int) {
	return get_param(reg, param_mode_1, pos), get_param(reg, param_mode_2, pos + 1)
}
