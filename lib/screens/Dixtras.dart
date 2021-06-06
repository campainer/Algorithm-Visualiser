import 'package:flutter/material.dart';
import 'package:project/Algo.dart';
import 'package:project/App_store.dart';
import 'package:project/screens/a*.dart';
import 'package:velocity_x/velocity_x.dart';

int x, y;

List<List<int>> mazeNodes;
List<List<bool>> visited;
List<Point> stack = <Point>[];

class Dixtras extends StatelessWidget {
  static String routname = "/dixtras";
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
                          Column(
                            children: [
                              RecursiveMaze(store: store),
                              SizedBox(height: 20),
                              Backtrcking(store: store),
                            ],
                          ),
                          Column(
                            children: [
                              Run(store: store),
                              SizedBox(height: 20),
                              Clear(store: store),
                            ],
                          )
                        ]),
            ),
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
        Refresh(1000, 1);
        x = store.x;
        y = store.y;
        List<int> d = [1, 0, -1, 0, 1];
        visited = List.generate(x, (i) => List.generate(y, (j) => false));
        Queue q = new Queue();
        q.push(Point.withParent(store.starti, store.startj, null));
        visited[store.starti][store.startj] = true;
        while (!q.empty() && store.stop) {
          Point curr = q.front();
          q.pop();
          ChangeVal1(curr.i, curr.j, 4);
          if (curr.i == store.endi && curr.j == store.endj) {
            List<Point> path = <Point>[];
            Point temp = curr;
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
              q.push(Point.withParent(a, b, curr));
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
