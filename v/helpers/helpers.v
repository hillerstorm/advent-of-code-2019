module helpers

import (
	math
	os
)

pub enum typ {
	wall
	open
}

pub struct Point {
pub:
	x int
	y int
	typ typ
}

pub fn (p Point) str() string {
	return '{$p.x, $p.y}'
}

pub fn (ps []Point) str() string {
	str := ps.map(it.str())
	return str.join(', ')
}

pub struct Wall {
	// fix for empty structs in sum types...
	foo int = 0
}

pub fn (w Wall) str() string {
	return 'Wall'
}

pub struct Open {
	// fix for empty structs in sum types...
	foo int = 0
}

pub fn (o Open) str() string {
	return 'Open'
}

pub struct Key {
pub:
	name string
}

pub fn (k Key) str() string {
	return 'Key($k.name)'
}

pub struct Door {
pub:
	name string
}

pub fn (d Door) str() string {
	return 'Door($d.name)'
}

pub type D18Typ = Wall | Open | Key | Door

pub fn (t D18Typ) str() string {
	match t {
		Wall {
			return it.str()
		}
		Open {
			return it.str()
		}
		Key {
			return it.str()
		}
		Door {
			return it.str()
		}
		else {
			return 'Unknown'
		}
	}
}

pub struct D18Point {
pub:
	x int
	y int
	typ D18Typ
	keys []string = []string
}

pub fn (p D18Point) str() string {
	return '{$p.x,$p.y,$p.keys}'
}

pub fn (ps []D18Point) str() string {
	str := ps.map(it.str())
	return str.join(', ')
}

pub type NodeValue = Point | D18Point

pub fn (v NodeValue) str() string {
	match v {
		Point {
			return it.str()
		}
		D18Point {
			return it.str()
		}
		else {
			return 'Unknown value'
		}
	}
}

pub fn (vs []NodeValue) str() string {
	str := vs.map(it.str())
	return str.join(', ')
}

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

pub fn permutations<T>(values []T) [][]T {
	if values.len == 0 {
		return [values]
	}

	// Weird way of initializing two-dimensional array, [][]T doesn't work
	mut res := []array_T
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

pub fn abs<T>(i T) T {
	return T(math.abs(f64(i)))
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
