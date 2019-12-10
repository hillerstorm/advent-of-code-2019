import (
	os
	intcode
	helpers
)

enum direction {
	left
	right
	up
	down
}

fn main() {
	input := os.read_file('../inputs/20191211.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	_, visited := run(500, 500, parsed.clone(), 0)

	width := 81
	height := 11

	grid, _ := run(width, height, parsed.clone(), 1)

	println('part 1: $visited')
	println('part 2:')

	for row := 0; row < height; row++ {
		slice := grid[width * row..width * row + width]
		ones := slice.filter(it == 1)
		if ones.len == 0 {
			continue
		}
		int_slice := slice.map(int(it))
		idx := int_slice.index(1)
		for i := idx; i < idx + 39; i++ {
			print(if slice[i] == 1 {
				'█'
			} else {
				'░'
			})
		}
		println('')
	}
}

fn run(width, height int, memory []i64, start_value i64) ([]i64, int) {
	mut grid := [i64(0)].repeat(width * height)
	mut x := width / 2
	mut y := height / 2

	grid[x + width * y] = start_value

	input_source := &intcode.Program{outputs: []}
	mut vm1 := &intcode.Program {
		memory: memory,
		input_source: input_source
	}
	mut dir := direction.up
	mut output_idx := 0
	mut visited := []int
	for {
		idx := x + width * y
		mut arr := &input_source.outputs
		arr << grid[idx]

		vm1.run()

		if vm1.done {
			break
		}

		if !idx in visited {
			visited << idx
		}

		grid[idx] = vm1.outputs[output_idx]
		// Can't map[tuple]xx so screw it, ugly match instead of lookup
		if vm1.outputs[output_idx + 1] == 0 {
			// turn left
			match	dir {
				.up {
					x--
					dir = .left
				}
				.down {
					x++
					dir = .right
				}
				.left {
					y++
					dir = .down
				}
				.right {
					y--
					dir = .up
				}
				else {}
			}
		} else {
			// turn right
			match	dir {
				.up {
					x++
					dir = .right
				}
				.down {
					x--
					dir = .left
				}
				.left {
					y--
					dir = .up
				}
				.right {
					y++
					dir = .down
				}
				else {}
			}
		}

		output_idx += 2
	}

	return grid, visited.len
}
