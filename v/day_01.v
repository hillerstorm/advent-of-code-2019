import (
	os
	math
)

fn main() {
	input := os.read_lines('../inputs/20191201.txt') or {
		println('input not found')
		return
	}
	mut part1 := 0
	mut part2 := 0
	for line in input {
		p1, p2 := fuel_req(line.int())
		part1 += p1
		part2 += p2
	}

	println('part 1: $part1')
	println('part 2: $part2')
}

fn fuel_req(mass int) (int, int) {
	req := int(math.floor(mass / 3) - 2)
	if req <= 0 {
		return req, 0
	}
	_, rest := fuel_req(req)
	return req, req + rest
}
