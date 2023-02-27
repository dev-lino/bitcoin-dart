import 'package:bitcoin_dart/bitcoin_dart.dart';
import 'package:bitcoin_dart/src/ecc.dart';

void main() {
  // var gx = "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  // var gy = "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
  // //var p = pow(2, 256) - pow(2, 32) - 977;
  // var p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
  // //print(p);
  // var curveP = BigInt.parse(
  //     'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F',
  //     radix: 16);
  // print(curveP);
  // var x = BigInt.parse(gx, radix: 16);
  // var y = BigInt.parse(gy, radix: 16);
  // //print(x);
  // //print(y);

  // var left = y.pow(2) % p;
  // var right = (x.pow(3) + BigInt.from(7)) % p;

  // //print(left);
  // //print(right);

  // var ySq = (x.modPow(BigInt.from(3), curveP) + BigInt.from(7)) % curveP;
  // var y2 = ySq.modPow((curveP + BigInt.one) ~/ BigInt.from(4), curveP);

  // print(ySq);
  // print(y2.modPow(BigInt.two, curveP));

  // print(y);
  // print(y2);

  // var esquerda = y.modPow(BigInt.two, curveP);
  // print(esquerda);
  // print(y * y % curveP);
  // var direita = x.modPow(BigInt.from(3), curveP) + BigInt.from(7) % curveP;
  // print(direita);

  // print(p);
  // print(curveP);

  var gx = "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  var gy = "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
  var p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
  var n = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141";

  var ggx = BigInt.parse(gx, radix: 16);
  var ggy = BigInt.parse(gy, radix: 16);
  var nn = BigInt.parse(n, radix: 16);
  var x = FieldElement(ggx, p);
  var y = FieldElement(ggy, p);
  var seven = FieldElement(BigInt.from(7), p);
  var zero = FieldElement(BigInt.zero, p);
  var G = Point(x, y, zero, seven);
  print((G * (nn)));

  //https://github.com/bitcoin/bitcoin/blob/master/test/functional/test_framework/key.py
  //https://gist.github.com/nlitsme/c9031c7b9bf6bb009e5a
  //https://github.com/PointyCastle/pointycastle/blob/master/lib/ecc/api.dart
  //https://github.com/nbd-wtf/dart-bip340/blob/master/lib/src/helpers.dart

  var teste =
      "0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  print(teste.substring(2));

  var teste2 = S256Field(teste);
  print(teste2);

  var GG = S256Point(
      "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
      "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");

  print(GG * nn);

  var z = "0xbc62d4b80d9e36da29c16c5d4d9f11731f36052c72401a76c23c0fb5a9b74423";
  var r = "0x37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6";
  var s = "0x8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec";
  var px = "0x04519fac3d910ca7e7138f7013706f619fa8f033e6ec6e09370ea38cee6a7574";
  var py = "0x82b51eab8c27c66e26c858a079bcdf4f1ada34cec420cafc7eac1a42216fb6c4";
  var point = S256Point(px, py);
  var s_inv = pow(BigInt.parse(s.substring(2), radix: 16), nn - BigInt.two, nn);
  var u = BigInt.parse(z.substring(2), radix: 16) * s_inv % nn;
  var v = BigInt.parse(r.substring(2), radix: 16) * s_inv % nn;
  print((GG * u + point * v).x.number);
  print((BigInt.parse(r.substring(2), radix: 16).toString()));

  var aaa = (GG * u + point * v).x.number;
  var bbb = (BigInt.parse(r.substring(2), radix: 16));
  print(aaa == bbb);

  print(randomBigInt());
}
