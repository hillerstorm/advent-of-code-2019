module intcode

pub struct Program {
pub mut:
	memory []int
	done bool = false
	result int = 0
	outputs []int = []int
	input_idx int = 0
	input_source &Program
	pos int = 0
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
				program.memory[program.memory[program.pos + 3]] = first + second

				program.pos += 4
			}
			'02' {
				first, second := program.get_two_params(param_modes)
				program.memory[program.memory[program.pos + 3]] = first * second

				program.pos += 4
			}
			'03' {
				if program.input_idx >= program.input_source.outputs.len {
					return
				}

				program.memory[program.memory[program.pos + 1]] = program.input_source.outputs[program.input_idx++]

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
				program.memory[program.memory[program.pos + 3]] = if first < second {
					1
				} else {
					0
				}

				program.pos += 4
			}
			'08' {
				first, second := program.get_two_params(param_modes)
				program.memory[program.memory[program.pos + 3]] = if first == second {
					1
				} else {
					0
				}

				program.pos += 4
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

fn (program &Program) get_param(param_modes []int) int {
	return program.get_param_with_offset(param_modes, 0)
}

fn (program &Program) get_param_with_offset(param_modes []int, offset int) int {
	return match param_modes[offset] {
		1 {
			 program.memory[program.pos + offset + 1]
		} else {
			 program.memory[program.memory[program.pos + offset + 1]]
		}
	}
}

fn (program &Program) get_two_params(param_modes []int) (int, int) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1)
}

fn (program &Program) get_three_params(param_modes []int) (int, int, int) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1), program.get_param_with_offset(param_modes, 2)
}
