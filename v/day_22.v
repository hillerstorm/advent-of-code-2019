import (
	bignum
	os
	strconv
)

enum typ {
	deal
	increment
	cut
}

struct Instruction {
	typ typ
	value int
}

const (
	zero = bignum.from_int(0)
	one = bignum.from_int(1)
	two = bignum.from_int(2)
)

fn main() {
	input := os.read_lines('../inputs/20191222.txt')?
	instructions := parse_instructions(input)

	part1 := get_part_1(10007, 2019, instructions)
	println('part 1: $part1')

	position := bignum.from_int(2020)
	size := bignum.from_u64(119315717514047)
	iterations := bignum.from_u64(101741582076661)
	addi, multi := get_part_2(size, instructions)

	all_multi := mod_pow(multi, iterations, size)
	all_addi := addi * (one - mod_pow(multi, iterations, size)) * inv(one - multi, size)

	part2 := (position * all_multi + all_addi) % size
	part2_str := strconv.parse_uint(part2.hexstr(), 16, 64)
	println('part 2: $part2_str')
}

fn mod_pow(_b, _e, m bignum.Number) bignum.Number {
  if bignum.cmp(m, one) == 0 {
    return zero
	}
	mut r := one
	mut b := _b % m
	mut e := _e
	for bignum.cmp(e, zero) > 0 {
		if bignum.cmp(e % two, one) == 0 {
			r = (r*b) % m
		}
		e = e / two
		b = b * b % m
	}
	return r
}

fn get_part_1(deck_len, start_idx int, instructions []Instruction) int {
	mut idx := start_idx

	for instruction in instructions {
		match instruction.typ {
			.deal {
				idx = deck_len - idx - 1
			}
			.increment {
				idx = (idx * instruction.value) % deck_len
			}
			.cut {
				idx = (idx - instruction.value) % deck_len
				if idx < 0 {
					idx = deck_len + idx
				}
			}
			else {}
		}
	}

	return idx
}

fn inv(i, size bignum.Number) bignum.Number {
	return mod_pow(i, size - two, size)
}

fn get_part_2(size bignum.Number, instructions []Instruction) (bignum.Number, bignum.Number) {
	mut addi := zero
	mut multi := one

	for instruction in instructions {
		match instruction.typ {
			.deal {
				multi = multi * bignum.from_int(-1)
				addi = addi + multi
			}
			.increment {
				multi = multi * inv(bignum.from_int(instruction.value), size)
			}
			.cut {
				addi = addi + (multi * bignum.from_int(instruction.value))
			}
			else {}
		}
	}

	return addi, multi
}

fn parse_instruction(line string) Instruction {
	parts := line.split(' ')[1..]
	return match parts[0] {
		'into' {
			&Instruction{typ.deal, 0}
		}
		'with' {
			&Instruction{typ.increment, parts[2].int()}
		}
		else {
			&Instruction{typ.cut, parts[0].int()}
		}
	}
}

fn parse_instructions(lines []string) []Instruction {
	return lines.map(parse_instruction(it))
}
