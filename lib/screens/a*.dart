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
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [
      ChangeVal,
      RemoveWall,
      ShowWall,
      ChangeStart,
      ChangeEnd,
      ChangeVal1,
      ChangeSpeed,
      ChangeStop,
      Refresh
    ]);
    AppStore store = VxState.store as AppStore;
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: MyGrid(store: store),
            ),
          ),
          Expanded(
            child: ListTile(
              title: store.stop
                  ? SpeedController(store: store)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          Backtrcking(store: store),
                          Run(store: store),
                          Clear(store: store),
                        ]),
            ),
          ),
        ],
      ),
    );
  }
}

class Clear extends StatelessWidget {
  const Clear({
    Key key,
    @required this.store,
  }) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.red;
          return null; // Defer to the widget's default.
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.blue;
          return null; // Defer to the widget's default.
        }),
      ),
      onPressed: () {
        for (int i = 0; i < 27; i++)
          for (int j = 0; j < store.y; j++)
            if (store.mazeNodes[i][j] > 0) ChangeVal1(i, j, 0);
      },
      child: Text('Clear'),
    );
  }
}

class SpeedController extends StatelessWidget {
  const SpeedController({
    Key key,
    @required this.store,
  }) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.orange[900],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Speed",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[50],
            ),
          ),
          Text(
            double.parse((10000 / store.speed).toStringAsFixed(2)).toString(),
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                child: Icon(Icons.remove),
                onPressed: () => ChangeSpeed(100),
                constraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
                shape: CircleBorder(),
                fillColor: Colors.grey[50],
              ),
              SizedBox(
                width: 10,
              ),
              RawMaterialButton(
                child: Icon(
                  Icons.pause,
                  color: Colors.grey[50],
                ),
                onPressed: () => ChangeStop(),
                constraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
                shape: CircleBorder(),
                fillColor: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              RawMaterialButton(
                child: Icon(Icons.add),
                onPressed: () => ChangeSpeed(-100),
                constraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
                shape: CircleBorder(),
                fillColor: Colors.grey[50],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Run extends StatelessWidget {
  const Run({
    Key key,
    @required this.store,
  }) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.red;
          return null; // Defer to the widget's default.
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.blue;
          return null; // Defer to the widget's default.
        }),
      ),
      onPressed: () async {
        Refresh(1000, true);
        x = 27;
        y = store.y;
        List<int> d = [1, 0, -1, 0, 1];
        visited = List.generate(x, (i) => List.generate(y, (j) => false));
        PriorityQueue q = new PriorityQueue();
        q.push(
            Node(store.starti, store.startj, 0, store.endi, store.endj, null));
        visited[store.starti][store.startj] = true;
        while (!q.empty() && store.stop) {
          Node curr = q.top();
          q.pop();
          ChangeVal1(curr.i, curr.j, 4);
          if (curr.i == store.endi && curr.j == store.endj) {
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
              await Future.delayed(Duration(microseconds: 2000));
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
              q.push(Node(a, b, curr.p + 1, store.endi, store.endj, curr));
            }
          }
          await Future.delayed(Duration(microseconds: store.speed));
        }
        if (store.stop) ChangeStop();
      },
      child: Text('Start'),
    );
  }
}

class Backtrcking extends StatelessWidget {
  const Backtrcking({
    Key key,
    @required this.store,
  }) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.red;
          return null; // Defer to the widget's default.
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) return Colors.blue;
          return null; // Defer to the widget's default.
        }),
      ),
      onPressed: () async {
        Refresh(1000, true);
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

        x = 27 ~/ 2;
        y = store.y ~/ 2;
        int totalNodes = x * y;
        mazeNodes = List.generate(x, (i) => List.generate(y, (j) => 0));
        visited = List.generate(x, (i) => List.generate(y, (j) => false));

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
          await Future.delayed(Duration(microseconds: store.speed));
        }
        if (store.stop) ChangeStop();
      },
      child: Text('Create Wall'),
    );
  }
}

class MyGrid extends StatelessWidget {
  const MyGrid({
    Key key,
    @required this.store,
  }) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: store.x * store.y,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: store.y),
        itemBuilder: (BuildContext context, int index) {
          return Block(
            store: store,
            index: index,
          );
        });
  }
}

class Block extends StatelessWidget {
  const Block({
    Key key,
    @required this.store,
    @required this.index,
  }) : super(key: key);

  final AppStore store;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!store.stop) ChangeVal(index ~/ store.y, index % store.y);
      },
      child: Padding(
        padding: store.mazeNodes[index ~/ store.y][index % store.y] == 0
            ? const EdgeInsets.all(0.3)
            : EdgeInsets.zero,
        child: Container(
          color: store.mazeNodes[index ~/ store.y][index % store.y] == 0
              ? Colors.grey
              : store.mazeNodes[index ~/ store.y][index % store.y] == 4
                  ? Colors.blue[100]
                  : store.mazeNodes[index ~/ store.y][index % store.y] == 5
                      ? Colors.lightBlue
                      : store.mazeNodes[index ~/ store.y][index % store.y] == 6
                          ? Colors.yellow
                          : Colors.grey[800],
          child: (store.starti == index ~/ store.y &&
                  store.startj == index % store.y)
              ? Draggable(
                  data: 2,
                  child: Container(
                    child: Center(
                      child: Icon(Icons.location_pin,
                          size: 13, color: Colors.white),
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
              : (store.endi == index ~/ store.y &&
                      store.endj == index % store.y)
                  ? Draggable(
                      data: 3,
                      child: Container(
                        child: Center(
                          child: Icon(Icons.location_searching,
                              size: 13, color: Colors.white),
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
                  : store.mazeNodes[index ~/ store.y][index % store.y] == 0 &&
                          !store.stop
                      ? DragTarget(
                          builder:
                              (context, List<int> candidateData, rejectedData) {
                            print(candidateData);
                            return Container();
                          },
                          onWillAccept: (data) {
                            return true;
                          },
                          onAccept: (data) {
                            data == 2
                                ? ChangeStart(index ~/ store.y, index % store.y)
                                : ChangeEnd(index ~/ store.y, index % store.y);
                          },
                        )
                      : null,
        ),
      ),
    );
  }
}
