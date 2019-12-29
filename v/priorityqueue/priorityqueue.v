module priorityqueue

import (
	helpers
	minheap
)

pub struct PriorityQueue {
	heap minheap.MinHeap
mut:
	insertion_order i64
}

pub fn (q &PriorityQueue) count() int {
	return q.heap.size
}

pub fn (q mut PriorityQueue) enqueue(item helpers.NodeValue, priority f64) {
	node := minheap.new_node(item, priority, q.insertion_order)
	q.insertion_order++
	q.heap.insert(node)
}

pub fn (q mut PriorityQueue) dequeue() helpers.NodeValue {
	return q.heap.remove_min()
}

pub fn new_queue() PriorityQueue {
	return PriorityQueue {
		heap: minheap.new_heap()
		insertion_order: 0
	}
}
