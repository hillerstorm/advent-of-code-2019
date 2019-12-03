import (
	os
	math
)

const (
	DX = {'R': 1, 'L': -1, 'D': 0, 'U': 0}
	DY = {'R': 0, 'L': 0, 'D': -1, 'U': 1}
)

struct Data {
	steps int
	dist int
}

fn main() {
	input := os.read_lines('../inputs/20191203.txt') or {
		println('input not found')
		return
	}

	first_coords := get_coords(input[0].split(','))
	second_coords := get_coords(input[1].split(','))

	mut closest_coord := 1000000
	mut fewest_steps := 1000000
	for key, data in first_coords {
		if !key in second_coords {
			continue
		}

		if data.dist < closest_coord {
			closest_coord = data.dist
		}

		steps := data.steps + second_coords[key].steps
		if steps < fewest_steps {
			fewest_steps = steps
		}
	}

	println('part 1: $closest_coord')
	println('part 2: $fewest_steps')
}

fn get_coords(path []string) map[string]Data {
	mut coords := map[string]Data
	mut x := 0
	mut y := 0
	mut step := 0
	for turn in path {
		steps := turn[1..].int()
		dir := turn[..1]
		x_inc := DX[dir]
		y_inc := DY[dir]
		for i := 0; i < steps; i++ {
			x += x_inc
			y += y_inc
			key := '${x},$y'
			if !key in coords {
				coords[key] = Data{step + i + 1, int(math.abs(x) + math.abs(y))}
			}
		}
		step += steps
	}

	return coords
}
