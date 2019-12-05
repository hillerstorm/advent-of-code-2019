module helpers

pub fn split_to_ints(input string, separator string) []int {
	split := input.trim_space().split(separator)
	ints := split.map(it.int())
	return ints
}
