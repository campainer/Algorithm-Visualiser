import 'package:velocity_x/velocity_x.dart';

class AppStore extends VxStore {
  var mazeNodes = List.generate(17, (i) => List.generate(13, (j) => 0));
}

class ChangeVal extends VxMutation<AppStore> {
  final int i, j;

  ChangeVal(this.i, this.j);
  @override
  perform() {
    store.mazeNodes[i][j] == 0
        ? store.mazeNodes[i][j] = 1
        : store.mazeNodes[i][j] = 0;
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
