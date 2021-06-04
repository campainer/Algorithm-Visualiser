import 'package:velocity_x/velocity_x.dart';

class AppStore extends VxStore {
  int x = 27, y = 19;
  var mazeNodes = List.generate(27, (i) => List.generate(19, (j) => 0));
  int starti = 1, startj = 1;
  int endi = 25, endj = 17;
  bool stop = false;
  int speed = 5000;
}

class ChangeVal extends VxMutation<AppStore> {
  final int i, j;

  ChangeVal(this.i, this.j);
  @override
  perform() {
    if (store.mazeNodes[i][j] == 0)
      store.mazeNodes[i][j] = 1;
    else if (store.mazeNodes[i][j] == 1) store.mazeNodes[i][j] = 0;
  }
}

class ChangeStop extends VxMutation<AppStore> {
  ChangeStop();
  @override
  perform() {
    store.stop = !store.stop;
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
  final int val;

  Refresh(this.val);
  @override
  perform() {
    store.speed = val;
    store.stop = !store.stop;
    for (int i = 0; i < store.x; i++)
      for (int j = 0; j < store.y; j++)
        if (store.mazeNodes[i][j] > 1) store.mazeNodes[i][j] = 0;
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
