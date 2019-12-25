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
	println('part 1: $visited')

	width := 81
	height := 11

	grid, _ := run(width, height, parsed.clone(), 1)

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

	mut vm := intcode.new_program(memory)
	mut dir := direction.up
	mut output_idx := 0
	mut visited := []int
	for {
		idx := x + width * y
		vm.input(grid[idx])

		vm.run()

		if vm.done {
			break
		}

		if !idx in visited {
			visited << idx
		}

		grid[idx] = vm.outputs[output_idx++]
		// Can't map[tuple]xx so screw it, ugly match instead of lookup
		if vm.outputs[output_idx++] == 0 {
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
	}

	return grid, visited.len
}
