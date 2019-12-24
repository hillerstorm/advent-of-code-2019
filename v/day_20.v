import (
	helpers
	os
	pathfinder
)

const (
	DX = [-1, 1, 0, 0]
	DY = [0, 0, -1, 1]
)

struct Portal {
	idx int
	target int
	dz int
}

fn main() {
	// 20191218_2.txt is a manually modified version with dead ends cut off
	input := os.read_lines('../inputs/20191220_2.txt')?
	width := input[0].len
	height := input.len

	start, goal, grid := setup_grid(input, width, height)

	part1 := pathfinder.bfs_to(start, goal, grid, width, get_neighbors_p1).len - 1
	println('part 1: $part1')

	part2 := pathfinder.bfs_to(start, goal, grid, width, get_neighbors_p2).len - 1
	println('part 2: $part2')
}

fn setup_grid(input []string, width, height int) (helpers.NodeValue, helpers.NodeValue, []helpers.NodeValue) {
	chars := input.join('').split('')
	mut start_idx := -1
	mut goal_idx := -1
	mut portals := map[string][]Portal
	mut grid := [helpers.NodeValue{}].repeat(chars.len)
	for i, chr in chars {
		x := i % (chars.len / height)
		y := i / width
		mut typ := helpers.typ.open
		if chr[0] == `#` || chr[0].is_letter() {
			typ = .wall
		}
		point := helpers.D20Point {
			x: x
			y: y
			typ: typ
		}
		grid[i] = point
		if chr[0] >= `A` && chr[0] <= `Z` && x > 0 && y > 0 && x < width - 1 && y < height - 1 {
			mut name := ''
			mut idx := -1
			if chars[i + 1] == '.' {
				name = chars[i - 1] + chr
				idx = i + 1
			} else if chars[i - 1] == '.' {
				name = chr + chars[i + 1]
				idx = i - 1
			} else if chars[i + width] == '.' {
				name = chars[i - width] + chr
				idx = i + width
			} else if chars[i - width] == '.' {
				name = chr + chars[i + width]
				idx = i - width
			} else {
				continue
			}

			if name == 'AA' {
				start_idx = idx
				continue
			} else if name == 'ZZ' {
				goal_idx = idx
				continue
			}

			mut dz := 1
			if x - 1 == 0 || y - 1 == 0 || x + 2 == width || y + 2 == height {
				dz = -1
			}
			if name in portals {
				mut arr := portals[name]
				arr << Portal{i, idx, dz}
				portals[name] = arr
			} else {
				portals[name] = [Portal{i, idx, dz}]
			}
		}
	}

	for _, portal in portals {
		a := get_point(grid[portal[0].target])
		grid[portal[1].idx] = helpers.D20Point {
			x: a.x
			y: a.y
			typ: a.typ
			dz: portal[0].dz
		}

		b := get_point(grid[portal[1].target])
		grid[portal[0].idx] = helpers.D20Point {
			x: b.x
			y: b.y
			typ: b.typ
			dz: portal[1].dz
		}
	}

	mut start := get_point(grid[start_idx])
	start.is_start = true
	mut goal := get_point(grid[goal_idx])
	goal.is_goal = true

	return grid[start_idx], grid[goal_idx], grid
}

fn get_point(value &helpers.NodeValue) helpers.D20Point {
	match *value {
		helpers.D20Point {
			return &it
		}
		else {
			panic('cant get point')
		}
	}
}

fn get_neighbors_p1(item helpers.NodeValue, grid []helpers.NodeValue, width int) []helpers.NodeValue {
	mut res := []helpers.NodeValue

	point := get_point(item)

	for i := 0; i < DX.len; i++ {
		other := grid[(point.x + DX[i]) + width * (point.y + DY[i])]
		if get_point(other).typ == .open {
			res << other
		}
	}

	return res
}

fn get_neighbors_p2(item helpers.NodeValue, grid []helpers.NodeValue, width int) []helpers.NodeValue {
	mut res := []helpers.NodeValue

	point := get_point(item)

	for i := 0; i < DX.len; i++ {
		if other := try_add(DX[i], DY[i], width, grid, point) {
			res << other
		}
	}

	return res
}

fn try_add(dx, dy, width int, grid []helpers.NodeValue, point &helpers.D20Point) ?helpers.NodeValue {
	next := get_point(grid[(point.x + dx) + width * (point.y + dy)])
	if next.typ == .open && !next.is_start && (!next.is_goal || point.z == 0) {
		new_z := point.z + next.dz
		if new_z <= 0 && (point.z == new_z || point.dz == 0) {
			mut other := helpers.NodeValue{}
			pt := helpers.D20Point {
				x: next.x
				y: next.y
				z: new_z
				typ: next.typ
				dz: next.dz
				is_goal: next.is_goal
			}
			other = pt
			return other
		}
	}

	return none
}
