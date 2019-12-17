import (
	helpers
	intcode
	strings
)

fn main() {
	input := helpers.read_file('../inputs/20191217.txt')?
	mut parsed := helpers.split_to_i64s(input, ',')

	movements := (
		'A,B,A,B,A,C,B,C,A,C\n' +
		'L,10,L,12,R,6\n' +
		'R,10,L,4,L,4,L,12\n' +
		'L,10,R,10,R,6,L,4\n' +
		'n\n'
	).bytes()
	moves_i64 := movements.map(i64(it))

	parsed[0] = i64(2)
	mut vm := &intcode.Program {
		memory: parsed.clone()
		input_source: &intcode.Program{outputs: []}
	}
	vm.input_source.outputs << moves_i64
	vm.run()

	mut grid := []string
	mut height := -1
	mut out_idx := 0
	for out_idx < vm.outputs.len {
		val := vm.outputs[out_idx]
		out_idx++
		match val {
			10 {
				if vm.outputs[out_idx - 2] == 10 {
					break
				} else {
					height++
				}
			}
			else {
				grid << string([byte(val)])
			}
		}
	}
	width := grid.len / height

	mut part2 := i64(0)
	mut builder := strings.new_builder(50)
	defer { builder.free() }
	for out_idx < vm.outputs.len {
		val := vm.outputs[out_idx]
		if val > 255 {
			part2 = val
			break
		} else {
			builder.write_b(byte(val))
		}
		out_idx++
	}

	mut sum := 0
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			idx := x + width * y
			val := grid[idx]
			if val == '#' {
				adj := get_adjacent_scaffold(grid, width, height, x, y)
				if adj.len > 2 {
					sum += x * y
					print('O')
					continue
				}
			}
			print(match val {
				'.'		{ ' ' }
				'#'		{ '█' }
				else	{ val }
			})
		}
		print('\n')
	}

	println('part 1: $sum')
	if vm.done && vm.outputs[vm.outputs.len - 1] != 10 {
		println('part 2: $vm.result')
	} else {
		println(builder.str())
	}
}

fn get_adjacent_scaffold(grid []string, width, height, x, y int) []helpers.Vec2 {
	mut res := []helpers.Vec2

	if x > 0 {
		res = try_coord(grid, res, width, height, x - 1, y    )
	}
	if x < width - 1 {
		res = try_coord(grid, res, width, height, x + 1, y    )
	}
	if y > 0 {
		res = try_coord(grid, res, width, height, x    , y - 1)
	}
	if y < height - 1 {
		res = try_coord(grid, res, width, height, x    , y + 1)
	}

	return res
}

fn try_coord(grid []string, res []helpers.Vec2, width, height, x, y int) []helpers.Vec2 {
	idx := x + width * y
	if grid[idx] == '#' {
		mut r := &res
		r << &helpers.vec2(x, y)
	}

	return res
}
