import 'package:bitcoin_dart/src/ecc.dart';

void main() {
  //var p1 = Point(-1, -1, 5, 7);
  //print(p1.toString());
  //var p2 = Point(-1, -2, 5, 7);

  // var p1 = Point(-1, -1, 5, 7);
  // var p2 = Point(-1, 1, 5, 7);
  // var inf = Point(null, null, 5, 7);
  // print(p1 + inf);
  // print(inf + p2);
  // print(p1 + p2);

  // var a = Point(3, 7, 5, 7);
  // var b = Point(-1, -1, 5, 7);
  // print(a + b == Point(2, -5, 5, 7));

  // var a = FieldElement(0, 223);
  // var b = FieldElement(7, 223);
  // var x = FieldElement(192, 223);
  // var y = FieldElement(105, 223);
  // var p1 = Point(x, y, a, b);
  // print(p1);

  var prime = 223;
  var a = FieldElement(0, prime);
  var b = FieldElement(7, prime);
  var x1 = FieldElement(192, prime);
  var y1 = FieldElement(105, prime);
  // var x2 = FieldElement(17, prime);
  // var y2 = FieldElement(56, prime);
  var p1 = Point(x1, y1, a, b);
  // var p2 = Point(x2, y2, a, b);
  // print(p1);
  // print(p2);
  // print(p1 + p2);
  print(p1 * 4);
  //var p2 = Point(null, null, a, b);
  //print(p1 + p1 + p1);
}
