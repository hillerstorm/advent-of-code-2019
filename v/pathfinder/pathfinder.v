module pathfinder

import (
	priorityqueue
)

pub fn bfs(
	start helpers.NodeValue,
	items []helpers.NodeValue,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue) []helpers.NodeValue,
) map[string]helpers.NodeValue {
	start_key := start.str()

	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start_key] = start

	for queue.count() > 0 {
		curr := queue.dequeue()

		neighbors := neighbor_fn(curr, items)
		mut to_add := []helpers.NodeValue
		for neighbor in neighbors {
			key := neighbor.str()
			if key in visited {
				continue
			}

			to_add << neighbor
		}

		for next in to_add {
			key := next.str()
			queue.enqueue(next, 0.0)
			visited[key] = curr
		}
	}

	return visited
}

pub fn dijkstra(
	start, goal helpers.NodeValue,
	items []helpers.NodeValue,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue) []helpers.NodeValue
	cost_fn fn (a, b helpers.NodeValue) f64
) []helpers.NodeValue {
	start_key := start.str()
	goal_key := goal.str()

	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start_key] = start
	mut costs := map[string]f64
	costs[start_key] = 0.0

	for queue.count() > 0 {
		curr := queue.dequeue()

		curr_key := curr.str()
		if curr_key == goal_key {
			break
		}

		neighbors := neighbor_fn(curr, items)
		mut to_add := []helpers.NodeValue
		for neighbor in neighbors {
			key := neighbor.str()
			if key in visited {
				continue
			}

			new_cost := costs[curr_key] + cost_fn(curr, neighbor)
			if key in costs && !(new_cost < costs[key]) {
				continue
			}

			to_add << neighbor
		}

		for next in to_add {
			key := next.str()
			new_cost := costs[curr_key] + cost_fn(curr, next)
			costs[key] = new_cost
			priority := new_cost
			queue.enqueue(next, priority)
			visited[key] = curr
		}
	}

	return generate_path(start, goal, visited)
}

pub fn astar(
	start, goal helpers.NodeValue,
	items []helpers.NodeValue,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue) []helpers.NodeValue
	heuristics_fn fn (a, b helpers.NodeValue) f64
	cost_fn fn (a, b helpers.NodeValue) f64
) []helpers.NodeValue {
	start_key := start.str()
	goal_key := goal.str()

	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start_key] = start
	mut costs := map[string]f64
	costs[start_key] = 0.0

	for queue.count() > 0 {
		curr := queue.dequeue()

		curr_key := curr.str()
		if curr_key == goal_key {
			break
		}

		neighbors := neighbor_fn(curr, items)
		mut to_add := []helpers.NodeValue
		for neighbor in neighbors {
			key := neighbor.str()
			if key in visited {
				continue
			}

			new_cost := costs[curr_key] + cost_fn(curr, neighbor)
			if key in costs && !(new_cost < costs[key]) {
				continue
			}

			to_add << neighbor
		}

		for next in to_add {
			key := next.str()
			new_cost := costs[curr_key] + cost_fn(curr, next)
			costs[key] = new_cost
			heuristics := heuristics_fn(goal, next)
			priority := new_cost + heuristics
			queue.enqueue(next, priority)
			visited[key] = curr
		}
	}

	return generate_path(start, goal, visited)
}

pub fn generate_path(start, goal helpers.NodeValue, visited map[string]helpers.NodeValue) []helpers.NodeValue {
	mut current := goal
	mut current_key := current.str()
	if !(current_key in visited) {
		return []
	}

	start_key := start.str()
	mut path := []helpers.NodeValue
	for current_key != start_key {
		path << current
		current = visited[current_key]
		current_key = current.str()
	}
	path << start

	return path.reverse()
}
