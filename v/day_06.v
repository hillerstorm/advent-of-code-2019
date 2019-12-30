import (
	os
)

fn main() {
	input := os.read_lines('../inputs/20191206.txt')?

	mut orbits := {
		'COM': ''
	}

	for line in input {
		split := line.split(')')
		orbits[split[1]] = split[0]
	}

	sum_direct := orbits.size - 1
	mut sum_indirect := 0
	mut san := []string
	mut you := []string

	for key, orb in orbits {
		if orb == '' || orb == 'COM' {
			continue
		}

		is_you := key == 'YOU'
		is_san := key == 'SAN'
		if is_you {
			you << orb
		} else if is_san {
			san << orb
		}

		mut curr := orbits[orb]
		for curr != '' {
			if is_you {
				you << curr
			} else if is_san {
				san << curr
			}

			sum_indirect++
			curr = orbits[curr]
		}
	}

	println('part 1: ${sum_direct + sum_indirect}')

	san = san.reverse()
	you = you.reverse()

	mut idx := 0
	for i, s in san {
			if s != you[i] {
					idx = i
					break
			}
	}

	println('part 2: ${san[idx..].len + you[idx..].len}')
}
