module helpers

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
	for i, current in values {
		mut others := values.filter(it != current)
		for perm in permutations(others) {
			// Have to copy perm to make it mutable since `for mut perm in ...` is invalid syntax...
			mut cp := perm
			cp << current
			res << cp
		}
	}

	return res
}
