import (
	os
)

const (
	levels = 100
	DX = [-1, 1, 0, 0]
	DY = [0, 0, -1, 1]
)

fn main() {
	input := os.read_lines('../inputs/20191224.txt')?
	part1 := get_part_1(input)
	println('part 1: $part1')

	part2 := get_part_2(input)
	println('part 2: $part2')
}

fn get_part_1(input []string) i64 {
	width := input.len

	mut grid := input.join('')
	mut states := [grid]
	for {
		mut next := grid.split('')
		for i, chr in grid {
			mut cnt := 0
			x := i % width
			y := i / width
			if x > 0 && grid[(x - 1) + width * y] == `#` {
				cnt++
			}
			if x < width - 1 && grid[(x + 1) + width * y] == `#` {
				cnt++
			}
			if y > 0 && grid[x + width * (y - 1)] == `#` {
				cnt++
			}
			if y < width - 1 && grid[x + width * (y + 1)] == `#` {
				cnt++
			}

			if chr == `.` && cnt in [1, 2] {
				next[i] = '#'
			} else if chr == `#` && cnt != 1 {
				next[i] = '.'
			}
		}

		grid = next.join('')
		if grid in states {
			break
		}

		states << grid
	}

	return bio_div_rating(grid)
}

fn bio_div_rating(state string) i64 {
	mut rating := i64(0)
	mut curr_rating := 1
	for chr in state {
		if chr == `#` {
			rating += curr_rating
		}
		curr_rating *= 2
	}

	return rating
}

fn get_part_2(input []string) i64 {
	width := input.len
	max_idx := width - 1
	mid := width / 2
	grid := input.join('')
	mut cells := map[string]bool
	mut edges := map[string][]string
	for x := 0; x < width; x++ {
		for y := 0; y < width; y++ {
			if x == mid && y == mid {
				continue
			}
			for level := -levels; level <= levels; level++ {
				prev_level := level - 1
				next_level := level + 1
				key := '$y,$x,$level'
				cells[key] = level == 0 && grid[x + width * y] == `#`
				mut key_edges := []string
				for i := 0; i < DX.len; i++ {
					xx := x + DX[i]
					yy := y + DY[i]
					if !(xx == mid && yy == mid) && xx >= 0 && xx < width && yy >= 0 && yy < width {
						key_edges << '$yy,$xx,$level'
					}
				}
				if y == 0 && prev_level >= -levels {
					key_edges << '${mid - 1},${mid},${prev_level}'
				}
				if x == 0 && prev_level >= -levels {
					key_edges << '${mid},${mid - 1},${prev_level}'
				}
				if x == max_idx && prev_level >= -levels {
					key_edges << '${mid},${mid + 1},${prev_level}'
				}
				if y == max_idx && prev_level >= -levels {
					key_edges << '${mid + 1},${mid},${prev_level}'
				}
				if y == mid - 1 && x == mid && next_level <= levels {
					for i := 0; i < width; i++ {
						key_edges << '0,$i,${next_level}'
					}
				}
				if y == mid && x == mid - 1 && next_level <= levels {
					for i := 0; i < width; i++ {
						key_edges << '$i,0,${next_level}'
					}
				}
				if y == mid && x == mid + 1 && next_level <= levels {
					for i := 0; i < width; i++ {
						key_edges << '$i,${max_idx},${next_level}'
					}
				}
				if y == mid + 1 && x == mid && next_level <= levels {
					for i := 0; i < width; i++ {
						key_edges << '${max_idx},$i,${next_level}'
					}
				}
				edges[key] = key_edges
			}
		}
	}

	for min := 0; min < 200; min++ {
		mut next := map[string]bool
		for key, is_bug in cells {
			mut cnt := 0
			for edge_key in edges[key] {
				if cells[edge_key] {
					cnt++
				}
			}
			if !is_bug && cnt in [1, 2] {
				next[key] = true
			} else if is_bug && cnt != 1 {
				next[key] = false
			} else {
				next[key] = is_bug
			}
		}
		cells = next
	}

	mut bug_count := 0
	for _, is_bug in cells {
		if is_bug {
			bug_count++
		}
	}

	return bug_count
}
