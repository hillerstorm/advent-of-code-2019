module minheap

import (
	helpers
)

pub struct HeapNode {
	priority f64
	insert_order i64
pub:
	value helpers.NodeValue
}

pub struct MinHeap {
pub mut:
	size int
	values []HeapNode
}

pub fn new_node(value helpers.NodeValue, priority f64, insert_order i64) HeapNode {
	return HeapNode {
		priority: priority
		insert_order: insert_order
		value: value
	}
}

pub fn new_heap() MinHeap {
	return MinHeap{
		size: 0
		values: []
	}
}

pub fn (n &HeapNode) compare_to(other &HeapNode) int {
	if n.priority < other.priority {
		return -1
	}
	if n.priority > other.priority {
		return 1
	}
	if n.insert_order < other.insert_order {
		return -1
	}
	if n.insert_order > other.insert_order {
		return 1
	}

	return 0
}

fn parent(i int) int {
	return (i - 1) / 2
}

fn (h mut MinHeap) swap(i, parent_idx int) {
	tmp := h.values[i]
	h.values[i] = h.values[parent_idx]
	h.values[parent_idx] = tmp
}

pub fn (h mut MinHeap) insert(value HeapNode) {
	h.size++
	mut i := h.size - 1
	if i >= h.values.len {
		h.values << value
	} else {
		h.values[i] = value
	}
	for i != 0 && h.values[parent(i)].compare_to(h.values[i]) == 1 {
		h.swap(i, parent(i))
		i = parent(i)
	}
}

fn left(i int) int {
	return 2 * i + 1
}

fn right(i int) int {
	return 2 * i + 2
}

fn (h mut MinHeap) min_heapify(i int) {
	mut j := i
	for {
		l := left(j)
		r := right(j)
		mut min := j

		if l < h.size && h.values[l].compare_to(h.values[j]) == -1 {
			min = l
		}
		if r < h.size && h.values[r].compare_to(h.values[min]) == -1 {
			min = r
		}

		if min != j {
			h.swap(j, min)
			j = min
			continue
		}

		break
	}
}

pub fn (h mut MinHeap) remove_min() helpers.NodeValue {
	if h.size == 0 {
		panic('no values')
	}

	if h.size == 1 {
		h.size--
		return h.values[0].value
	}

	min := h.values[0]
	h.values[0] = h.values[h.size - 1]
	h.size--
	h.min_heapify(0)

	return min.value
}
