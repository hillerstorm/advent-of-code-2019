import (
	os
	intcode
	helpers
)

const (
	width = 42
	height = 42
	dx = [ 0, 0, -1, 1]
	dy = [-1, 1,  0, 0]
)

fn main() {
	input := os.read_file('../inputs/20191215.txt')?
	parsed := helpers.split_to_i64s(input, ',')

	mut grid := [0].repeat(width * height)
	start_x := width / 2
	start_y := height / 2

	x, y := traverse(parsed.clone(), mut grid, start_x, start_y, 0, i64(0))
	print_grid(grid, start_x, start_y, x, y)
	station_distance := grid[x + width * y]
	println('part 1: $station_distance')

	time := fill_grid(mut grid, x, y)
	println('part 2: $time')
}

fn traverse(memory []i64, grid mut []int, x, y, steps int, pos i64) (int, int) {
	mut sys_x := -1
	mut sys_y := -1
	for i in [0, 1, 2, 3] {
		new_x := x + dx[i]
		new_y := y + dy[i]

		idx := new_x + width * new_y
		if grid[idx] != 0 {
			continue
		}

		mut vm := intcode.new_program(memory.clone())
		vm.pos = pos
		vm.input(i + 1)
		vm.run()

		result := vm.outputs[vm.outputs.len - 1]

		if result == 0 {
			grid[idx] = -1
			continue
		}

		new_steps := steps + 1
		if grid[idx] == 0 || grid[idx] > new_steps {
			grid[idx] = new_steps
		}

		if result == 2 {
			sys_x = new_x
			sys_y = new_y
		}

		xx, yy := traverse(vm.memory.clone(), mut grid, new_x, new_y, new_steps, vm.pos)
		if xx != -1 {
			sys_x = xx
			sys_y = yy
		}
	}

	return sys_x, sys_y
}

fn fill_grid(grid mut []int, x, y int) int {
	grid[x + width * y] = -2

	mut time := 0
	mut adjacent := get_adjacent(grid)
	for adjacent.len > 0 {
		for idx in adjacent {
			grid[idx] = -2
		}
		time++
		adjacent = get_adjacent(grid)
	}

	return time
}

fn get_adjacent(grid []int) []int {
	mut oxygen := []int

	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			idx := x + width * y
			if grid[idx] == -2 {
				west  := (x - 1) + width * (y    )
				east  := (x + 1) + width * (y    )
				north := (x    ) + width * (y - 1)
				south := (x    ) + width * (y + 1)

				if grid[west] >= 0 {
					oxygen << west
				}
				if grid[east] >= 0 {
					oxygen << east
				}
				if grid[north] >= 0 {
					oxygen << north
				}
				if grid[south] >= 0 {
					oxygen << south
				}
			}
		}
	}

	return oxygen
}

fn print_grid(grid []int, start_x, start_y, sys_x, sys_y int) {
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			idx := grid[x + width * y]
			print(if x == start_x && y == start_y {
				'0'
			} else if x == sys_x && y == sys_y {
				'X'
			} else if idx >= 0 {
				' '
			} else {
				'█'
			})
		}
		print('\n')
	}
}
