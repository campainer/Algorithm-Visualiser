import 'package:flutter/material.dart';
import 'package:project/Algo.dart';
import 'package:project/App_store.dart';
import 'package:project/screens/a*.dart';
import 'package:velocity_x/velocity_x.dart';

int x, y;

List<List<int>> mazeNodes;
List<List<bool>> visited1;
List<List<bool>> visited2;
List<Point> stack = <Point>[];

class DoubleDixtras extends StatelessWidget {
  static String routname = "/doubleDixtras";
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
        visited1 = List.generate(x, (i) => List.generate(y, (j) => false));
        visited2 = List.generate(x, (i) => List.generate(y, (j) => false));
        var l1 = List.generate(x, (i) => List.generate(y, (j) => Point(i, j)));
        var l2 = List.generate(x, (i) => List.generate(y, (j) => Point(i, j)));
        Queue q1 = new Queue(), q2 = new Queue();
        q1.push(l1[store.starti][store.startj]);
        q2.push(l2[store.endi][store.endj]);
        visited1[store.starti][store.startj] = true;
        visited2[store.endi][store.endj] = true;
        while (!q1.empty() && !q2.empty() && store.stop) {
          Point curr1 = q1.front(), curr2 = q2.front();
          q1.pop();
          q2.pop();
          ChangeVal1(curr1.i, curr1.j, 4);
          ChangeVal1(curr2.i, curr2.j, 4);
          if (visited2[curr1.i][curr1.j]) {
            List<Point> path = <Point>[];
            Point temp = curr1;
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
            temp = l2[curr1.i][curr1.j];
            while (temp != null) {
              ChangeVal1(temp.i, temp.j, 6);
              temp = temp.parent;
              await Future.delayed(Duration(microseconds: 2000));
            }
            break;
          }
          if (visited1[curr2.i][curr2.j]) {
            List<Point> path = <Point>[];
            Point temp = l1[curr2.i][curr2.j];
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
            temp = curr2;
            while (temp != null) {
              ChangeVal1(temp.i, temp.j, 6);
              temp = temp.parent;
              await Future.delayed(Duration(microseconds: 2000));
            }
            break;
          }
          for (int i = 0; i < 4; i++) {
            int a = curr1.i + d[i], b = curr1.j + d[i + 1];
            if (a >= 0 &&
                a < x &&
                b >= 0 &&
                b < y &&
                store.mazeNodes[a][b] != 1 &&
                !visited1[a][b]) {
              visited1[a][b] = true;
              ChangeVal1(a, b, 5);
              l1[a][b].parent = curr1;
              q1.push(l1[a][b]);
            }
          }
          for (int i = 0; i < 4; i++) {
            int a = curr2.i + d[i], b = curr2.j + d[i + 1];
            if (a >= 0 &&
                a < x &&
                b >= 0 &&
                b < y &&
                store.mazeNodes[a][b] != 1 &&
                !visited2[a][b]) {
              visited2[a][b] = true;
              ChangeVal1(a, b, 5);
              l2[a][b].parent = curr2;
              q2.push(l2[a][b]);
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
