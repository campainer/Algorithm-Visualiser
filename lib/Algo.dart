class Node {
  Node(this.i, this.j, this.p, int endi, int endj, this.parent) {
    h = (i - endi).abs() + (j - endj).abs();
    f = h + p;
  }
  final int i;
  Node parent;
  final int j;
  int h;
  final p;
  int f;
  bool visited = false;
}

class PriorityQueue {
  List<Node> A = <Node>[];
  void heapify_down(var i) {
    var left = i * 2, right = i * 2 + 1;
    var smallest = i;
    if (left < size() && A[left].f < A[i].f) {
      smallest = left;
    }
    if (right < size() && A[right].f < A[smallest].f) {
      smallest = right;
    }
    if (smallest != i) {
      Node temp = A[i];
      A[i] = A[smallest];
      A[smallest] = temp;
      heapify_down(smallest);
    }
  }

  void heapify_up(var i) {
    // check if the node at index `i` and its parent violate the heap property
    if (i > 0 && A[i ~/ 2].f > A[i].f) {
      Node temp = A[i];
      A[i] = A[i ~/ 2];
      A[i ~/ 2] = temp;

      // call heapify-up on the parent
      heapify_up(i ~/ 2);
    }
  }

  size() {
    return A.length;
  }

  bool empty() {
    return size() == 0;
  }

  void push(Node key) {
    A.add(key);
    int index = size() - 1;
    heapify_up(index);
  }

  void pop() {
    A[0] = A.last;
    A.removeLast();
    heapify_down(0);
  }

  Node top() {
    return A[0];
  }
}
