import (
	os
	intcode
	helpers
	term
	time
	flag
)

const (
	width = 45
	height = 23
	sleep_delay = 10
)

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	print := fp.bool('print', true, 'print game while calculating part 2')
	fp.finalize()?

	input := os.read_file('../inputs/20191213.txt')?
	mut parsed := helpers.split_to_i64s(input, ',')

	part1 := part_one(parsed.clone())
	println('part 1: $part1')

	parsed[0] = 2
	part2 := part_two(parsed, print)
	println('part 2: $part2')
}

fn part_one(memory []i64) int {
	mut vm := intcode.new_program(memory)
	vm.run()

	mut blocks := 0
	for i := 0; i < vm.outputs.len; i += 3 {
		if vm.outputs[i + 2] == 2 {
			blocks++
		}
	}

	return blocks
}

fn part_two(memory []i64, print bool) i64 {
	mut grid := [' '].repeat(width * height)

	mut vm := intcode.new_program(memory)

	mut paddle_pos := 0
	mut ball_pos := 0
	mut score := i64(0)
	mut output_idx := 0

	for !vm.done {
		vm.run()

		for output_idx < vm.outputs.len {
			x := int(vm.outputs[output_idx++])
			y := int(vm.outputs[output_idx++])
			value := vm.outputs[output_idx++]

			if x == -1 && y == 0 {
				score = value
				continue
			}

			if value == 3 {
				paddle_pos = x
			} else if value == 4 {
				ball_pos = x
			}

			if print {
				grid[x + width * y] = tile_str(value, x, y)
			}
		}

		vm.input(if ball_pos < paddle_pos {
			-1
		} else if ball_pos > paddle_pos {
			1
		} else {
			0
		})

		if print {
			print_grid(grid, score)
		}
	}

	return score
}

fn tile_str(tile i64, x, y int) string {
	return match tile {
		1 {
			if x == 0 && y == 0 {
				'┏'
			} else if x == width - 1 && y == 0 {
				'┓'
			} else if x == 0 || x == width - 1 {
				'┃'
			} else {
				'━'
			}
		}
		2 {'▣'}
		3 {'▀'}
		4 {'◆'}
		else {' '}
	}
}

fn print_grid(grid []string, score i64) {
	term.erase_clear()

	for y := 0; y < height; y++ {
		println(grid[width * y..width * y + width].join(''))
	}

	score_str := ' $score '
	left := (width - score_str.len - 4) / 2
	left_str := '━'.repeat(left)
	right_str := '━'.repeat(width - left - score_str.len - 4)

	println('┗$left_str┥$score_str┝$right_str┛')
	time.sleep_ms(sleep_delay)
}
