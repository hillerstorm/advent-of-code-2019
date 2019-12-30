import (
	helpers
	os
	pathfinder
	priorityqueue
)

fn main() {
	// 20191218_2.txt is a manually modified version with dead ends cut off
	input := os.read_lines('../inputs/20191218_2.txt')?
	width := input[0].len
	height := input.len
	p1_start, mut grid, all_keys := setup_grid(input, width, height)
	mut p1_keys := all_keys.keys()
	p1_keys.sort()

	part1 := get_path_len(p1_start, grid, p1_keys, width)
	println('part 1: $part1')

	p1_start_idx := p1_start.x + width * p1_start.y
	tl_start                      := new_start(p1_start.x - 1, p1_start.y - 1)
	tr_start                      := new_start(p1_start.x + 1, p1_start.y - 1)
	bl_start                      := new_start(p1_start.x - 1, p1_start.y + 1)
	br_start                      := new_start(p1_start.x + 1, p1_start.y + 1)
	grid[p1_start_idx - width - 1] = tl_start
	grid[p1_start_idx - width + 1] = tr_start
	grid[p1_start_idx + width - 1] = bl_start
	grid[p1_start_idx + width + 1] = br_start
	grid[p1_start_idx            ] = new_wall( p1_start.x    , p1_start.y    )
	grid[p1_start_idx         - 1] = new_wall( p1_start.x - 1, p1_start.y    )
	grid[p1_start_idx         + 1] = new_wall( p1_start.x + 1, p1_start.y    )
	grid[p1_start_idx - width    ] = new_wall( p1_start.x    , p1_start.y - 1)
	grid[p1_start_idx + width    ] = new_wall( p1_start.x    , p1_start.y + 1)

	mut tl_keys := []string
	mut tr_keys := []string
	mut bl_keys := []string
	mut br_keys := []string
	for k, v in all_keys {
		if v.x <= p1_start.x && v.y <= p1_start.y {
			tl_keys << k
		}
		else if v.x >= p1_start.x && v.y <= p1_start.y {
			tr_keys << k
		}
		else if v.x <= p1_start.x && v.y >= p1_start.y {
			bl_keys << k
		}
		else if v.x >= p1_start.x && v.y >= p1_start.y {
			br_keys << k
		}
	}
	tl_keys.sort()
	tr_keys.sort()
	bl_keys.sort()
	br_keys.sort()

	tl_path := get_path_len(tl_start, grid, tl_keys, width)
	tr_path := get_path_len(tr_start, grid, tr_keys, width)
	bl_path := get_path_len(bl_start, grid, bl_keys, width)
	br_path := get_path_len(br_start, grid, br_keys, width)

	// This one only works on the real input, not on the examples
	// since it just skips doors that does not have a key in the
	// same area as the door is in... hey, it works...
	println('part 2: ${tl_path + tr_path + bl_path + br_path}')
}

fn new_wall(x, y int) helpers.D18Point {
	return helpers.D18Point {
		x: x
		y: y
		typ: helpers.Wall{0}
	}
}

fn new_start(x, y int) helpers.D18Point {
	return helpers.D18Point {
		x: x
		y: y
		typ: helpers.Open{0}
	}
}

fn get_point(value helpers.NodeValue) ?helpers.D18Point {
	match value {
		helpers.D18Point {
			return it
		}
		else {
			return none
		}
	}
}

fn get_path_len(start helpers.D18Point, grid []helpers.D18Point, all_keys []string, width int) int {
	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start.str()] = start

	for queue.count() > 0 {
		curr := get_point(queue.dequeue()) or {
			continue
		}

		if curr.keys.eq(all_keys) {
			return pathfinder.generate_path(start, curr, visited).len - 1
		}

		neighbors := get_neighbors(curr, grid, all_keys, width)
		for next in neighbors {
			mut keys := curr.keys.clone()
			match next.typ {
				helpers.Key {
					if !(it.name in keys) {
						keys << it.name
					}
				}
				else {}
			}
			keys.sort()
			new := helpers.D18Point {
				x: next.x
				y: next.y
				typ: next.typ
				keys: keys
			}
			key := new.str()
			if key in visited {
				continue
			}

			queue.enqueue(new, 0.0)
			visited[key] = curr
		}
	}

	return -1
}

fn setup_grid(input []string, width, height int) (helpers.D18Point, []helpers.D18Point, map[string]helpers.D18Point) {
	chars := input.join('').split('')
	mut start := helpers.D18Point{}
	mut keys := map[string]helpers.D18Point
	mut grid := [helpers.D18Point{}].repeat(chars.len)
	for i, chr in chars {
		mut typ := helpers.D18Typ{}
		open := helpers.Open{0}
		typ = open
		mut is_key := false
		mut is_start := false
		if chr[0] >= `a` && chr[0] <= `z` {
			is_key = true
			key := helpers.Key{chr}
			typ = key
		}
		if chr[0] >= `A` && chr[0] <= `Z` {
			door := helpers.Door{chr}
			typ = door
		}
		if chr[0] == `#` {
			wall := helpers.Wall{0}
			typ = wall
		}
		if chr[0] == `@` {
			is_start = true
		}
		point := helpers.D18Point {
			x: i % (chars.len / height)
			y: i / width
			typ: typ
		}
		grid[i] = point

		if is_key {
			keys[chr] = point
		}
		if is_start {
			start = point
		}
	}

	return start, grid, keys
}

pub fn manhattan_distance(a, b helpers.D18Point) f64 {
	return helpers.abs(a.x - b.x) + helpers.abs(a.y - b.y)
}

pub fn get_neighbors(point helpers.D18Point, grid []helpers.D18Point, all_keys []string, width int) []helpers.D18Point {
	mut res := []helpers.D18Point

	if point.x > 0 {
		value := grid[(point.x - 1) + width * point.y]
		if can_add(value, point.keys, all_keys) {
			res << value
		}
	}
	if point.x < width - 1 {
		value := grid[(point.x + 1) + width * point.y]
		if can_add(value, point.keys, all_keys) {
			res << value
		}
	}
	if point.y > 0 {
		value := grid[point.x + width * (point.y - 1)]
		if can_add(value, point.keys, all_keys) {
			res << value
		}
	}
	if point.y < width - 1 {
		value := grid[point.x + width * (point.y + 1)]
		if can_add(value, point.keys, all_keys) {
			res << value
		}
	}

	return res
}

fn can_add(point helpers.D18Point, current_keys, all_keys []string) bool {
	match point.typ {
		helpers.Open {
			return true
		}
		helpers.Key {
			return true
		}
		helpers.Door {
			req_key := it.name.to_lower()
			if !(req_key in all_keys) || req_key in current_keys {
				return true
			}
		}
		else {}
	}

	return false
}
