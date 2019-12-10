import (
	os
	math
	helpers
)

struct Target {
	angle f64
	distance f64
	point &helpers.Vec2
}

fn main() {
	input := os.read_lines('../inputs/20191210.txt')?
	mut asteroids := []helpers.Vec2
	for y, line in input {
		for x, chr in line.trim_space() {
			if chr == `#` {
				asteroids << &helpers.vec2(x, y)
			}
		}
	}

	mut max_targets := 0
	mut targets := []Target
	for i := 0; i < asteroids.len; i++ {
		asteroid := &asteroids[i]
		mut unique_targets := []string
		mut all_targets := []Target
		for j := 0; j < asteroids.len; j++ {
			if i == j {
				continue
			}
			other := &asteroids[j]
			angle := math.atan2(other.x - asteroid.x, other.y - asteroid.y)
			str_angle := angle.str()
			if !str_angle in unique_targets {
				unique_targets << str_angle
			}
			all_targets << Target{angle, asteroid.distance_to(other), other}
		}
		if unique_targets.len > max_targets {
			max_targets = unique_targets.len
			targets = all_targets
		}
	}

	targets.sort_with_compare(compare_by_angle_and_distance)

	mut sorted_target_groups := map[string][]Target
	for target in targets {
		str := target.angle.str()
		if str in sorted_target_groups {
			mut group := sorted_target_groups[str]
			group << target
			sorted_target_groups[str] = group
		} else {
			sorted_target_groups[str] = [target]
		}
	}

	mut vaporized := 0
	mut last_target_x := -1
	mut last_target_y := -1
	for vaporized < 200 {
		keys := sorted_target_groups.keys()
		for key in keys {
			group := &sorted_target_groups[key]
			target := &group[0]
			last_target_x = target.point.x
			last_target_y = target.point.y
			vaporized++
			if vaporized == 200 {
				break
			}
			if group.len == 1 {
				sorted_target_groups.delete(key)
			} else {
				sorted_target_groups[key] = group[1..]
			}
		}
	}

	println('part 1: $max_targets')
	println('part 2: ${100 * last_target_x + last_target_y}')
}

pub fn compare_by_angle_and_distance(a, b &Target) int {
	if a.angle < b.angle {
		return 1
	} else if a.angle > b.angle {
		return -1
	} else {
		if a.distance < b.distance {
			return -1
		} else if a.distance > b.distance {
			return 1
		} else {
			return 0
		}
	}
}
