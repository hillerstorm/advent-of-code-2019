module intcode

pub struct Program {
pub mut:
	memory []i64
	done bool = false
	result i64 = i64(0)
	outputs []i64
	input_idx int = 0
	inputs []i64
	pos i64 = i64(0)
	relative_base i64 = i64(0)
}

pub fn new_program(memory []i64) &Program {
	return &Program {
		memory: memory
		inputs: []
		outputs: []
	}
}

pub fn (p &Program) str() string {
	return '{done: $p.done, outputs: ${p.outputs}, inputs: ${p.inputs}'
}

pub fn (p mut Program) input(i i64) {
	p.inputs << i
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

		opcode := val[3..]
		match opcode {
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
				inputs := program.inputs
				if program.input_idx >= inputs.len {
					return
				}

				program.write(param_modes, 1, inputs[program.input_idx++])

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
			} else {
				println('Invalid opcode: $opcode')
				return
			}
		}
	}
}

fn (program mut Program) write(param_modes []int, param_offset int, value i64) {
	idx := match param_modes[param_offset - 1] {
		2 {
			program.relative_base + program.get(program.pos + param_offset)
		} else {
			program.get(program.pos + param_offset)
		}
	}

	program.ensure_capacity(idx)
	program.memory[idx] = value
}

fn (program mut Program) ensure_capacity(cap i64) {
	for cap >= i64(program.memory.len) {
		program.memory << i64(0)
	}
}

fn (program mut Program) get_param(param_modes []int) i64 {
	return program.get_param_with_offset(param_modes, 0)
}

fn (program mut Program) get_param_with_offset(param_modes []int, offset int) i64 {
	idx := match param_modes[offset] {
		1 {
			program.pos + offset + 1
		}
		2 {
			program.relative_base + program.get(program.pos + offset + 1)
		} else {
			program.get(program.pos + offset + 1)
		}
	}

	return program.get(idx)
}

fn (program mut Program) get(idx i64) i64 {
	program.ensure_capacity(idx)
	return program.memory[idx]
}

fn (program mut Program) get_two_params(param_modes []int) (i64, i64) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1)
}

fn (program mut Program) get_three_params(param_modes []int) (i64, i64, i64) {
	return program.get_param(param_modes), program.get_param_with_offset(param_modes, 1), program.get_param_with_offset(param_modes, 2)
}
