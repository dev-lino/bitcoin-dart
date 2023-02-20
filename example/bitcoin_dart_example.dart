import 'package:bitcoin_dart/src/ecc.dart';

void main() {
  //var p1 = Point(-1, -1, 5, 7);
  //print(p1.toString());
  //var p2 = Point(-1, -2, 5, 7);

  var p1 = Point(-1, -1, 5, 7);
  var p2 = Point(-1, 1, 5, 7);
  var inf = Point(null, null, 5, 7);
  print(p1 + inf);
  print(inf + p2);
  print(p1 + p2);

  var a = Point(3, 7, 5, 7);
  var b = Point(-1, -1, 5, 7);
  print(a + b == Point(2, -5, 5, 7));
}
