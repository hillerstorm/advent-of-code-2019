import (
	helpers
)

const (
	image_width = 25
	image_height = 6
	image_pixels = image_width * image_height
)

fn main() {
	pixels := helpers.read_file('../inputs/20191208.txt')?

	num_layers := pixels.len / image_pixels
	mut layers := []string
	for i := 0; i < num_layers; i++ {
		start := i * image_pixels
		layers << pixels[start..start+image_pixels]
	}

	mut fewest := image_pixels + 1
	mut sum := 0
	mut final_image := [' '].repeat(image_pixels)

	for layer in layers {
		mut black := 0
		mut white := 0
		mut transparent := 0

		for i, pixel in layer {
			if pixel == `2` {
				transparent++
			} else {
				if pixel == `0` {
					black++
				} else if pixel == `1` {
					white++
				}

				if final_image[i] == ' ' {
					final_image[i] = if pixel == `1` {
						'█'
					} else {
						'░'
					}
				}
			}
		}

		if black < fewest {
			fewest = black
			sum = white * transparent
		}
	}

	println('part 1: $sum')
	println('part 2:')
	for i := 0; i < image_height; i++ {
		start := i * image_width
		println(final_image[start..start+image_width].join(''))
	}
}
