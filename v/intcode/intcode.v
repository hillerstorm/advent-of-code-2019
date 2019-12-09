module intcode

pub struct Program {
pub mut:
	memory []i64
	done bool = false
	result i64 = i64(0)
	outputs []i64 = []i64
	input_idx int = 0
	input_source &Program
	pos i64 = i64(0)
	relative_base i64 = i64(0)
}

pub fn (program mut Program) run() {
	for {
		mut val := program.memory[program.pos].str()
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
				first, second := program.get_two_params(param_modes)
				program.write(param_modes, 3, first + second)

				program.pos += 4
			}
			'02' {
				first, second := program.get_two_params(param_modes)
				program.write(param_modes, 3, first * second)

				program.pos += 4
			}
			'03' {
				if program.input_idx >= program.input_source.outputs.len {
					return
				}

				program.write(param_modes, 1, program.input_source.outputs[program.input_idx++])

				program.pos += 2
			}
			'04' {
				param := program.get_param(param_modes)
				program.outputs << param

				program.pos += 2
			}
			'05' {
				first, second := program.get_two_params(param_modes)

				program.pos = if first != 0 {
					second
				} else {
					program.pos + 3
				}
			}
			'06' {
				first, second := program.get_two_params(param_modes)

				program.pos = if first == 0 {
					second
				} else {
					program.pos + 3
				}
			}
			'07' {
				first, second := program.get_two_params(param_modes)
				program.write(param_modes, 3, if first < second {
					1
				} else {
					0
				})

				program.pos += 4
			}
			'08' {
				first, second := program.get_two_params(param_modes)
				program.write(param_modes, 3, if first == second {
					1
				} else {
					0
				})

				program.pos += 4
			}
			'09' {
				param := program.get_param(param_modes)
				program.relative_base += param

				program.pos += 2
			}
			'99' {
				program.done = true
				if program.outputs.len == 0 {
					program.result = program.memory[0]
				} else {
					program.result = program.outputs.last()
				}
				return
			}
		}
	}
}

fn (program mut Program) write(param_modes []int, param_offset int, value i64) {
	idx := match param_modes[param_offset - 1] {
		2 {
			program.relative_base + program.memory[program.pos + param_offset]
		} else {
			program.memory[program.pos + param_offset]
		}
	}

	for idx >= i64(program.memory.len) {
		program.memory << i64(0)
	}

	program.memory[idx] = value
}

fn (program &Program) get_param(param_modes []int) i64 {
	return program.get_param_with_offset(param_modes, 0)
}

fn (program &Program) get_param_with_offset(param_modes []int, offset int) i64 {
	return match param_modes[offset] {
		1 {
			program.memory[program.pos + offset + 1]
		}
		2 {
			program.memory[program.relative_base + program.memory[program.pos + offset + 1]]
		} else {
			program.memory[program.memory[program.pos + offset + 1]]
		}
	}
}

fn (program &Program) get_two_params(param_modes []int) (i64, i64) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1)
}

fn (program &Program) get_three_params(param_modes []int) (i64, i64, i64) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1), program.get_param_with_offset(param_modes, 2)
}
