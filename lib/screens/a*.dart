import 'package:flutter/material.dart';
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
    VxState.watch(context, on: [ChangeVal, RemoveWall, ShowWall]);
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
                      onTap: () => ChangeVal(index ~/ 13, index % 13),
                      child: Padding(
                        padding: const EdgeInsets.all(0.3),
                        child: Container(
                          color: store.mazeNodes[index ~/ 13][index % 13] == 0
                              ? Colors.grey
                              : Colors.indigoAccent,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
              child: Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.red;
                  return null; // Defer to the widget's default.
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () async {
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
                  if (i < x - 1 && !visited[i + 1][j] || i == x - 1) {
                    ShowWall(gridi + 1, gridj - 1);
                    ShowWall(gridi + 1, gridj);
                    ShowWall(gridi + 1, gridj + 1);
                  }
                  if (j < y - 1 && !visited[i][j + 1] || j == y - 1) {
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
                mazeNodes = List.generate(x, (i) => List.generate(y, (j) => 0));
                visited =
                    List.generate(x, (i) => List.generate(y, (j) => false));

                var current = Point(0, 0);
                visited[0][0] = true;

                int visitedCount = 1;
                while (visitedCount < totalNodes) {
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
                  await Future.delayed(Duration(milliseconds: 50));
                }
              },
              child: Text('Create Wall'),
            ),
          )),
        ],
      ),
    );
  }
}
