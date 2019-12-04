import os

fn main() {
	input := os.read_file('../inputs/20191204.txt')?
	split := input.trim_space().split('-')
	min := split[0].int()
	max := split[1].int()
	mut p1 := 0
	mut p2 := 0
	for i := min; i <= max; i++ {
		str := i.str()
		if (str[0] == str[1] ||
			str[1] == str[2] ||
			str[2] == str[3] ||
			str[3] == str[4] ||
			str[4] == str[5]) &&
			str[1] >= str[0] &&
			str[2] >= str[1] &&
			str[3] >= str[2] &&
			str[4] >= str[3] &&
			str[5] >= str[4] {
			p1++
			if (str[0] == str[1] && str[1] != str[2]) ||
				(str[1] == str[2] && str[0] != str[1] && str[2] != str[3]) ||
				(str[2] == str[3] && str[1] != str[2] && str[3] != str[4]) ||
				(str[3] == str[4] && str[2] != str[3] && str[4] != str[5]) ||
				(str[4] == str[5] && str[3] != str[4]) {
				p2++
			}
		}
	}

	println('part 1: $p1')
	println('part 2: $p2')
}
