import 'package:velocity_x/velocity_x.dart';

class AppStore extends VxStore {
  int x = 27, y = 19;
  var mazeNodes = List.generate(27, (i) => List.generate(19, (j) => 0));
  int starti = 1, startj = 1;
  int endi = 21, endj = 15;
  bool stop = false;
  int speed = 5000;
}

class ChangeVal extends VxMutation<AppStore> {
  final int i, j;

  ChangeVal(this.i, this.j);
  @override
  perform() {
    if (store.mazeNodes[i][j] == 1)
      store.mazeNodes[i][j] = 0;
    else
      store.mazeNodes[i][j] = 1;
  }
}

class ChangeStop extends VxMutation<AppStore> {
  ChangeStop();
  @override
  perform() {
    store.stop = !store.stop;
  }
}

class Create extends VxMutation<AppStore> {
  final double w, h;

  Create(this.w, this.h);
  @override
  perform() {
    store.x = (h * 0.6) ~/ 18;
    if (store.x % 2 == 0) store.x++;
    store.y = w ~/ 18;
    if (store.y % 2 == 0) store.y++;
    store.stop = false;
    store.mazeNodes =
        List.generate(store.x, (i) => List.generate(store.y, (j) => 0));
  }
}

class ChangeSpeed extends VxMutation<AppStore> {
  final int val;
  ChangeSpeed(this.val);
  @override
  perform() {
    store.speed += val;
  }
}

class Refresh extends VxMutation<AppStore> {
  final int val, val1;
  final bool stopval = true;

  Refresh(this.val, this.val1);
  @override
  perform() {
    store.speed = val;
    store.stop = stopval;
    for (int i = 0; i < store.x; i++)
      for (int j = 0; j < store.y; j++)
        if (store.mazeNodes[i][j] > val1) store.mazeNodes[i][j] = 0;
  }
}

class ChangeVal1 extends VxMutation<AppStore> {
  final int i, j, val;

  ChangeVal1(this.i, this.j, this.val);
  @override
  perform() {
    store.mazeNodes[i][j] = val;
  }
}

class RemoveWall extends VxMutation<AppStore> {
  final int i, j;

  RemoveWall(this.i, this.j);
  @override
  perform() {
    store.mazeNodes[i][j] = 0;
  }
}

class ShowWall extends VxMutation<AppStore> {
  final int i, j;

  ShowWall(this.i, this.j);
  @override
  perform() {
    store.mazeNodes[i][j] = 1;
  }
}

class ChangeStart extends VxMutation<AppStore> {
  final int i, j;

  ChangeStart(this.i, this.j);
  @override
  perform() {
    store.starti = i;
    store.startj = j;
  }
}

class ChangeEnd extends VxMutation<AppStore> {
  final int i, j;

  ChangeEnd(this.i, this.j);
  @override
  perform() {
    store.endi = i;
    store.endj = j;
  }
}
