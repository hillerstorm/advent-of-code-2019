import (
	os
	math
	helpers
)

struct Moon {
mut:
	x int
	y int
	z int
	vel_x int = 0
	vel_y int = 0
	vel_z int = 0
}

fn main() {
	input := os.read_lines('../inputs/20191212.txt')?
	moons := input.map(parse_moon(it))
	println('part 1: ${moons.clone().part_one()}')
	println('part 2: ${moons.part_two()}')
}

fn (moons []Moon) part_one() int {
	for i := 0; i < 1000; i++ {
		moons.step()
	}
	return moons.calculate_energy()
}

fn (moons []Moon) part_two() i64 {
	mut lcm := i64(1)
	for i := 0; i < 3; i++ {
		val := cycles(moons.clone(), i)
		lcm = math.lcm(lcm, val)
	}
	return lcm
}

fn (moons []Moon) step() {
	for j := 0; j < moons.len; j++ {
		mut moon := &moons[j]
		for k := 0; k < moons.len; k++ {
			if j == k {
				continue
			}

			moon.modify_velocity(&moons[k])
		}
	}

	for j := 0; j < moons.len; j++ {
		mut moon := &moons[j]
		moon.apply_velocity()
	}
}

fn cycles(moons []Moon, idx int) i64 {
	mut res := i64(1)
	moons.step()
	for !moons.velocity_zero(idx) {
		moons.step()
		res++
	}

	return res * 2
}

fn (moons []Moon) velocity_zero(idx int) bool {
	zeros := moons.filter((idx == 0 && it.vel_x == 0) || (idx == 1 && it.vel_y == 0) || (idx == 2 && it.vel_z == 0))
	return zeros.len == moons.len
}

fn (m mut Moon) modify_velocity(other &Moon) {
	if other.x > m.x {
		m.vel_x++
	} else if other.x < m.x {
		m.vel_x--
	}

	if other.y > m.y {
		m.vel_y++
	} else if other.y < m.y {
		m.vel_y--
	}

	if other.z > m.z {
		m.vel_z++
	} else if other.z < m.z {
		m.vel_z--
	}
}

fn (m mut Moon) apply_velocity() {
	m.x += m.vel_x
	m.y += m.vel_y
	m.z += m.vel_z
}

fn (m []Moon) calculate_energy() int {
	mut sum := 0
	for moon in m {
		pot_energy := helpers.abs(moon.x) + helpers.abs(moon.y) + helpers.abs(moon.z)
		kin_energy := helpers.abs(moon.vel_x) + helpers.abs(moon.vel_y) + helpers.abs(moon.vel_z)
		sum += pot_energy * kin_energy
	}
	return sum
}

fn parse_moon(line string) Moon {
	nums := helpers.split_to_ints(line.replace('<x=', '').replace(' y=', '').replace(' z=', '').replace('>', ''), ',')
	return &Moon {
		x: nums[0]
		y: nums[1]
		z: nums[2]
	}
}
