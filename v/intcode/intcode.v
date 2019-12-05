module intcode

pub fn run(memory_base, inputs []int) int {
	mut memory := memory_base.clone()
	mut output := ''
	mut pos := 0
	mut input_idx := 0
	for {
		mut val := memory[pos].str()
		for val.len < 5 {
			val = '0$val'
		}
		param_modes := [
			val[2..3].int(),
			val[1..2].int(),
			val[0..1].int(),
		]
		match val[3..] {
			'01' {
				first, second := get_two_params(memory, param_modes, pos)
				memory[memory[pos + 3]] = first + second
				pos += 4
			}
			'02' {
				first, second := get_two_params(memory, param_modes, pos)
				memory[memory[pos + 3]] = first * second
				pos += 4
			}
			'03' {
				memory[memory[pos + 1]] = inputs[input_idx++]
				pos += 2
			}
			'04' {
				param := get_param(memory, param_modes[0], pos)
				output += param.str()
				pos += 2
			}
			'05' {
				first, second := get_two_params(memory, param_modes, pos)
				pos = if first != 0 {
					second
				} else {
					pos + 3
				}
			}
			'06' {
				first, second := get_two_params(memory, param_modes, pos)
				pos = if first == 0 {
					second
				} else {
					pos + 3
				}
			}
			'07' {
				first, second := get_two_params(memory, param_modes, pos)
				memory[memory[pos + 3]] = if first < second {
					1
				} else {
					0
				}
				pos += 4
			}
			'08' {
				first, second := get_two_params(memory, param_modes, pos)
				memory[memory[pos + 3]] = if first == second {
					1
				} else {
					0
				}
				pos += 4
			}
			'99' {
				if output == '' {
					output = memory[0].str()
				}
				break
			}
		}
	}

	return output.trim_left('0').int()
}

fn get_param(memory []int, param_mode, pos int) int {
	return match param_mode {
		1 {
			 memory[pos + 1]
		}
		else {
			 memory[memory[pos + 1]]
		}
	}
}

fn get_two_params(memory, param_modes []int, pos int) (int, int) {
	return get_param(memory, param_modes[0], pos), get_param(memory, param_modes[1], pos + 1)
}

fn get_three_params(memory, param_modes []int, pos int) (int, int, int) {
	return get_param(memory, param_modes[0], pos), get_param(memory, param_modes[1], pos + 1), get_param(memory, param_modes[2], pos + 2)
}
