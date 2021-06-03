import 'package:flutter/material.dart';
import 'package:project/Algo.dart';
import 'package:project/App_store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math' as math;

int x, y;

class Point {
  final int i, j;
  Point(this.i, this.j);
  Point pickNeighbor() {
    List<Point> neighbors = <Point>[];
    if (j > 0 && !visited[i][j - 1]) {
      neighbors.add(Point(i, j - 1));
    }
    if (j < y - 1 && !visited[i][j + 1]) {
      neighbors.add(Point(i, j + 1));
    }
    if (i > 0 && !visited[i - 1][j]) {
      neighbors.add(Point(i - 1, j));
    }
    if (i < x - 1 && !visited[i + 1][j]) {
      neighbors.add(Point(i + 1, j));
    }
    if (neighbors.length > 0) {
      int n = math.Random.secure().nextInt(neighbors.length);
      return neighbors[n];
    } else {
      return null;
    }
  }
}

List<List<int>> mazeNodes;
List<List<bool>> visited;
List<Point> stack = <Point>[];

class AStar extends StatelessWidget {
  static String routname = "/A*";
  int numberInRow = 13;
  int numberOfSquares = 13 * 17;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [
      ChangeVal,
      RemoveWall,
      ShowWall,
      ChangeStart,
      ChangeEnd,
      ChangeVal1,
      ChangeStop,
      Refresh
    ]);
    AppStore store = VxState.store as AppStore;
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInRow),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (!store.stop) ChangeVal(index ~/ 13, index % 13);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(0.3),
                        child: Container(
                          color: store.mazeNodes[index ~/ 13][index % 13] == 0
                              ? Colors.grey
                              : store.mazeNodes[index ~/ 13][index % 13] == 4
                                  ? Colors.purple
                                  : store.mazeNodes[index ~/ 13][index % 13] ==
                                          5
                                      ? Colors.lightBlue
                                      : store.mazeNodes[index ~/ 13]
                                                  [index % 13] ==
                                              6
                                          ? Colors.yellow
                                          : Colors.indigoAccent,
                          child: (store.starti == index ~/ 13 &&
                                  store.startj == index % 13)
                              ? Draggable(
                                  data: 2,
                                  child: Container(
                                    child: Center(
                                      child: Icon(Icons.location_pin,
                                          size: 15, color: Colors.white),
                                    ),
                                    color: Colors.pink,
                                  ),
                                  feedback: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Center(
                                      child: Icon(
                                        Icons.location_pin,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: Colors.pink,
                                  ),
                                  childWhenDragging: Container(),
                                )
                              : (store.endi == index ~/ 13 &&
                                      store.endj == index % 13)
                                  ? Draggable(
                                      data: 3,
                                      child: Container(
                                        child: Center(
                                          child: Icon(Icons.location_searching,
                                              size: 15, color: Colors.white),
                                        ),
                                        color: Colors.orange,
                                      ),
                                      feedback: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Center(
                                          child: Icon(
                                            Icons.location_searching,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.orange,
                                      ),
                                      childWhenDragging: Container(),
                                    )
                                  : store.mazeNodes[index ~/ 13][index % 13] ==
                                              0 &&
                                          !store.stop
                                      ? DragTarget(
                                          builder: (context,
                                              List<int> candidateData,
                                              rejectedData) {
                                            print(candidateData);
                                            return Container();
                                          },
                                          onWillAccept: (data) {
                                            return true;
                                          },
                                          onAccept: (data) {
                                            data == 2
                                                ? ChangeStart(
                                                    index ~/ 13, index % 13)
                                                : ChangeEnd(
                                                    index ~/ 13, index % 13);
                                          },
                                        )
                                      : null,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            child: ListTile(
              title: store.stop
                  ? InkWell(
                      onTap: () {
                        ChangeStop();
                      },
                      child: Container(
                        child: Center(
                          child:
                              Icon(Icons.pause, size: 50, color: Colors.white),
                        ),
                        color: Colors.orange[900],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.red;
                                return null; // Defer to the widget's default.
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.blue;
                                return null; // Defer to the widget's default.
                              }),
                            ),
                            onPressed: () async {
                              Refresh();
                              removeWall(Point a, Point b) {
                                int gridi = a.i * 2 + 1;
                                int gridj = a.j * 2 + 1;
                                var dx = a.i - b.i;
                                var dy = a.j - b.j;
                                RemoveWall(gridi, gridj);
                                // onShowCurrentNode(gridi,gridj);
                                if (dx == -1) {
                                  RemoveWall(gridi + 1, gridj);
                                  // onShowCurrentNode(gridi + 1, gridj);
                                } else if (dx == 1) {
                                  RemoveWall(gridi - 1, gridj);
                                  // onShowCurrentNode(gridi - 1, gridj);
                                } else if (dy == -1) {
                                  RemoveWall(gridi, gridj + 1);
                                  // onShowCurrentNode(gridi, gridj + 1);
                                } else if (dy == 1) {
                                  RemoveWall(gridi, gridj - 1);
                                  // onShowCurrentNode(gridi, gridj - 1);
                                }
                              }

                              void showWall(Point a) {
                                int gridi = a.i * 2 + 1;
                                int gridj = a.j * 2 + 1;
                                int i = a.i;
                                int j = a.j;
                                if (j > 0 && !visited[i][j - 1] || j == 0) {
                                  ShowWall(gridi - 1, gridj - 1);
                                  ShowWall(gridi, gridj - 1);
                                  ShowWall(gridi + 1, gridj - 1);
                                }
                                if (i < x - 1 && !visited[i + 1][j] ||
                                    i == x - 1) {
                                  ShowWall(gridi + 1, gridj - 1);
                                  ShowWall(gridi + 1, gridj);
                                  ShowWall(gridi + 1, gridj + 1);
                                }
                                if (j < y - 1 && !visited[i][j + 1] ||
                                    j == y - 1) {
                                  ShowWall(gridi + 1, gridj + 1);
                                  ShowWall(gridi, gridj + 1);
                                  ShowWall(gridi - 1, gridj + 1);
                                }
                                if (i > 0 && !visited[i - 1][j] || i == 0) {
                                  ShowWall(gridi - 1, gridj + 1);
                                  ShowWall(gridi - 1, gridj);
                                  ShowWall(gridi - 1, gridj - 1);
                                }
                              }

                              x = 17 ~/ 2;
                              y = 13 ~/ 2;
                              int totalNodes = x * y;
                              mazeNodes = List.generate(
                                  x, (i) => List.generate(y, (j) => 0));
                              visited = List.generate(
                                  x, (i) => List.generate(y, (j) => false));

                              var current = Point(0, 0);
                              visited[0][0] = true;

                              int visitedCount = 1;
                              while (visitedCount < totalNodes && store.stop) {
                                var next = current.pickNeighbor();
                                if (next != null) {
                                  stack.add(current);
                                  showWall(current);
                                  removeWall(current, next);
                                  visited[next.i][next.j] = true;
                                  visitedCount++;
                                  current = next;
                                } else if (stack.isNotEmpty) {
                                  showWall(current);
                                  removeWall(current, current);
                                  current = stack.removeLast();
                                }
                                await Future.delayed(
                                    Duration(milliseconds: 50));
                              }
                              if (store.stop) ChangeStop();
                            },
                            child: Text('Create Wall'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.red;
                                return null; // Defer to the widget's default.
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.blue;
                                return null; // Defer to the widget's default.
                              }),
                            ),
                            onPressed: () async {
                              Refresh();
                              x = 17;
                              y = 13;
                              List<int> d = [1, 0, -1, 0, 1];
                              visited = List.generate(
                                  x, (i) => List.generate(y, (j) => false));
                              PriorityQueue q = new PriorityQueue();
                              q.push(Node(store.starti, store.startj, 0,
                                  store.endi, store.endj, null));
                              visited[store.starti][store.startj] = true;
                              while (!q.empty() && store.stop) {
                                Node curr = q.top();
                                q.pop();
                                ChangeVal1(curr.i, curr.j, 4);
                                if (curr.i == store.endi &&
                                    curr.j == store.endj) {
                                  List<Point> path = <Point>[];
                                  Node temp = curr;
                                  while (temp != null) {
                                    path.add(Point(temp.i, temp.j));
                                    temp = temp.parent;
                                  }
                                  while (path.isNotEmpty) {
                                    Point k = path.last;
                                    ChangeVal1(k.i, k.j, 6);
                                    path.removeLast();
                                    await Future.delayed(
                                        Duration(milliseconds: 30));
                                  }
                                  break;
                                }
                                for (int i = 0; i < 4; i++) {
                                  int a = curr.i + d[i], b = curr.j + d[i + 1];
                                  if (a >= 0 &&
                                      a < x &&
                                      b >= 0 &&
                                      b < y &&
                                      store.mazeNodes[a][b] == 0 &&
                                      !visited[a][b]) {
                                    visited[a][b] = true;
                                    ChangeVal1(a, b, 5);
                                    q.push(Node(a, b, curr.p + 1, store.endi,
                                        store.endj, curr));
                                  }
                                }
                                await Future.delayed(
                                    Duration(milliseconds: 50));
                              }
                              if (store.stop) ChangeStop();
                            },
                            child: Text('Start'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.red;
                                return null; // Defer to the widget's default.
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return Colors.blue;
                                return null; // Defer to the widget's default.
                              }),
                            ),
                            onPressed: () {
                              for (int i = 0; i < 17; i++)
                                for (int j = 0; j < 13; j++)
                                  if (store.mazeNodes[i][j] > 0)
                                    ChangeVal1(i, j, 0);
                            },
                            child: Text('Clear'),
                          ),
                        ]),
            ),
          ),
        ],
      ),
    );
  }
}
