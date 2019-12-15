import (
	os
	math
)

struct Chemical {
	name string
	amount u64
	reqs []Chemical
}

const (
	total_ore = 1000000000000
)

fn main() {
	input := os.read_lines('../inputs/20191214.txt')?
	chemicals := input.map(parse_line(it))

	mut chem_map := map[string]Chemical
	for chemical in chemicals {
		chem_map[chemical.name] = chemical
	}

	fuel := chem_map['FUEL']
	part1, _ := fuel.get_ore_count(chem_map, map[string]u64, fuel.amount)

	mut current := total_ore
	mut min := total_ore / part1
	mut max := current
	for {
		ore_count, _ := fuel.get_ore_count(chem_map, map[string]u64, current)
		if ore_count > total_ore {
			if current - min == 1 {
				break
			}
			max = current
			current = current - ((current - min) / u64(2))
		} else if ore_count < total_ore {
			min = current
			current = min + ((max - min) / u64(2))
		} else {
			min = current
			break
		}
	}

	println('part 1: $part1')
	println('part 2: $min')
}

fn (chemical &Chemical) get_ore_count(chemicals map[string]Chemical, sprs map[string]u64, num u64) (u64, map[string]u64) {
	mut spares := sprs
	mut res := u64(0)
	for req in chemical.reqs {
		if req.name == 'ORE' {
			times := u64(math.ceil(f64(num) / f64(chemical.amount)))
			leftovers := (times * chemical.amount) - num
			if leftovers > 0 {
				if chemical.name in spares {
					spares[chemical.name] = spares[chemical.name] + leftovers
				} else {
					spares[chemical.name] = leftovers
				}
			}
			return chemical.reqs[0].amount * times, spares
		}

		chem := chemicals[req.name]
    mut req_amnt := req.amount * (num / chemical.amount)

		if req.name in spares {
			spare_amnt := u64(math.min(f64(spares[req.name]), f64(req_amnt)))
			req_amnt -= spare_amnt
			spares[req.name] = spares[req.name] - spare_amnt
		}

		if req_amnt == 0 {
			continue
		}

		times := u64(math.ceil(f64(req_amnt) / f64(chem.amount)))
		amnt := chem.amount * times

		mut ores := u64(0)
		ores, spares = chem.get_ore_count(chemicals, spares, amnt)
		res += ores

		leftovers := amnt - req_amnt
		if leftovers > 0 {
			if req.name in spares {
				spares[req.name] = spares[req.name] + leftovers
			} else {
				spares[req.name] = leftovers
			}
		}
	}

	return res, spares
}

fn parse_line(line string) Chemical {
	parts := line.split(' => ')
	reqs := parts[0].split(', ')
	parsed_reqs := reqs.map(parse_chemical(it.split(' ')))
	chemical := parts[1].split(' ')

	return &Chemical {
		name: chemical[1]
		amount: chemical[0].u64()
		reqs: parsed_reqs
	}
}

fn parse_chemical(str []string) Chemical {
	return &Chemical {
		name: str[1]
		amount: str[0].u64()
		reqs: []
	}
}
