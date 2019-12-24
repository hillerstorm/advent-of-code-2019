module pathfinder

import (
	priorityqueue
)

pub fn bfs(
	start helpers.NodeValue,
	items []helpers.NodeValue,
	width int,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue, width int) []helpers.NodeValue,
) map[string]helpers.NodeValue {
	start_key := start.str()

	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start_key] = start

	for queue.count() > 0 {
		curr := queue.dequeue()

		neighbors := neighbor_fn(curr, items, width)
		for next in neighbors {
			key := next.str()
			if key in visited {
				continue
			}
			queue.enqueue(next, 0.0)
			visited[key] = curr
		}
	}

	return visited
}

pub fn bfs_to(
	start, goal helpers.NodeValue,
	items []helpers.NodeValue,
	width int,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue, width int) []helpers.NodeValue,
) []helpers.NodeValue {
	start_key := start.str()
	goal_key := goal.str()

	mut queue := priorityqueue.new_queue()
	queue.enqueue(start, 0.0)
	mut visited := map[string]helpers.NodeValue
	visited[start_key] = start

	for queue.count() > 0 {
		curr := queue.dequeue()

		curr_key := curr.str()
		if curr_key == goal_key {
			break
		}

		neighbors := neighbor_fn(curr, items, width)
		for next in neighbors {
			key := next.str()
			if key in visited {
				continue
			}
			queue.enqueue(next, 0.0)
			visited[key] = curr
		}
	}

	return generate_path(start, goal, visited)
}

pub fn dijkstra(
	start, goal helpers.NodeValue,
	items []helpers.NodeValue,
	width int,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue, width int) []helpers.NodeValue
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

		neighbors := neighbor_fn(curr, items, width)
		for next in neighbors {
			key := next.str()
			if key in visited {
				continue
			}

			new_cost := costs[curr_key] + cost_fn(curr, next)
			if key in costs && !(new_cost < costs[key]) {
				continue
			}

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
	width int,
	neighbor_fn fn (itm helpers.NodeValue, items []helpers.NodeValue, width int) []helpers.NodeValue
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

		neighbors := neighbor_fn(curr, items, width)
		for next in neighbors {
			key := next.str()
			if key in visited {
				continue
			}

			new_cost := costs[curr_key] + cost_fn(curr, next)
			if key in costs && !(new_cost < costs[key]) {
				continue
			}

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
