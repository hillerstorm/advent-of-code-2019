module helpers

import (
	math
	os
)

pub struct Vec2 {
pub:
	x int
	y int
}

pub fn vec2(x, y int) Vec2 {
	return Vec2{x, y}
}

pub fn (p &Vec2) str() string {
	return '($p.x, $p.y)'
}

pub fn (v &Vec2) distance_to(w &Vec2) f64 {
	return math.sqrt(math.pow(v.x - w.x, 2) + math.pow(v.y - w.y, 2))
}

pub fn split_to_ints(input string, separator string) []int {
	split := input.trim_space().split(separator)
	ints := split.map(it.int())
	return ints
}

pub fn split_to_i64s(input string, separator string) []i64 {
	split := input.trim_space().split(separator)
	ints := split.map(it.i64())
	return ints
}

pub fn permutations(values []int) [][]int {
	if values.len == 0 {
		return [values]
	}

  // Weird way of initializing two-dimensional array, [] doesn't work
	// Have to force type by adding an empty array and then removing
	mut res := [[]int]
	res.delete(0)
	for current in values {
		others := values.filter(it != current)
		for perm in permutations(others) {
			// Have to copy perm to make it mutable since `for mut perm in ...` is invalid syntax...
			mut cp := perm
			cp << current
			res << cp
		}
	}

	return res
}

pub fn read_file(path string) ?string {
	file := os.read_file(path) or {
		return error(err)
	}
	return file.trim_space()
}

pub fn abs(i int) int {
	return int(math.abs(i))
}

pub fn join(arr []int) int {
	return arr.reduce(combine, 0)
}

pub fn combine(acc, i int) int {
	mut pow := 10
	for i >= pow {
		pow *= 10
	}
	return acc * pow + i
}
