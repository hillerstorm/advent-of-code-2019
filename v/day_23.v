import (
	helpers
	intcode
)

fn main() {
	input := helpers.read_file('../inputs/20191223.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut vms := []&intcode.Program
	mut output_idxs := [0].repeat(50)
	for i := 0; i < 50; i++ {
		mut vm := intcode.new_program(parsed.clone())
		vm.input(i)
		vms << vm
	}

	mut part1_found := false
	mut nat_x := i64(-1)
	mut nat_y := i64(-1)
	mut idle_rounds := 0
	mut last_y := i64(-1)

	for {
		mut idle_vms := []int
		for i, _vm in vms {
			mut vm := _vm
			if vm.done {
				continue
			}
			if vm.input_idx >= vm.inputs.len {
				idle_vms << i
			}
		}
		if idle_vms.len == vms.len {
			idle_rounds++
		}
		if idle_rounds > 1 {
			if nat_y == last_y {
				println('part 2: $nat_y')
				break
			}
			last_y = nat_y
			mut vm := vms[0]
			vm.input(nat_x)
			vm.input(nat_y)
			idle_rounds = 0
		} else {
			for idx in idle_vms {
				mut vm := vms[idx]
				vm.input(-1)
			}
		}
		for i := 0; i < vms.len; i++ {
			mut vm := vms[i]
			vm.run()
			mut out_idx := output_idxs[i]
			for out_idx < vm.outputs.len {
				addr := vm.outputs[out_idx++]
				x := vm.outputs[out_idx++]
				y := vm.outputs[out_idx++]
				if addr == 255 {
					if !part1_found {
						println('part 1: $y')
						part1_found = true
					}
					nat_x = x
					nat_y = y
					continue
				}
				mut out_vm := vms[addr]
				out_vm.input(x)
				out_vm.input(y)
				output_idxs[i] = out_idx
			}
		}
	}
}
