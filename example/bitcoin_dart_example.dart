import 'dart:convert';
import 'package:bitcoin_dart/bitcoin_dart.dart';
import 'package:bitcoin_dart/src/ecc.dart';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';

void main() {
  // // var gx = "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  // // var gy = "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
  // // //var p = pow(2, 256) - pow(2, 32) - 977;
  // // var p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
  // // //print(p);
  // // var curveP = BigInt.parse(
  // //     'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F',
  // //     radix: 16);
  // // print(curveP);
  // // var x = BigInt.parse(gx, radix: 16);
  // // var y = BigInt.parse(gy, radix: 16);
  // // //print(x);
  // // //print(y);

  // // var left = y.pow(2) % p;
  // // var right = (x.pow(3) + BigInt.from(7)) % p;

  // // //print(left);
  // // //print(right);

  // // var ySq = (x.modPow(BigInt.from(3), curveP) + BigInt.from(7)) % curveP;
  // // var y2 = ySq.modPow((curveP + BigInt.one) ~/ BigInt.from(4), curveP);

  // // print(ySq);
  // // print(y2.modPow(BigInt.two, curveP));

  // // print(y);
  // // print(y2);

  // // var esquerda = y.modPow(BigInt.two, curveP);
  // // print(esquerda);
  // // print(y * y % curveP);
  // // var direita = x.modPow(BigInt.from(3), curveP) + BigInt.from(7) % curveP;
  // // print(direita);

  // // print(p);
  // // print(curveP);

  // var gx = "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  // var gy = "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
  // var p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
  var n = "4000000000000000000020108A2E0CC0D99F8A5EF";

  // var ggx = BigInt.parse(gx, radix: 16);
  // var ggy = BigInt.parse(gy, radix: 16);
  var nn = BigInt.parse(n, radix: 16);
  // var x = FieldElement(ggx, p);
  // var y = FieldElement(ggy, p);
  // var seven = FieldElement(BigInt.from(7), p);
  // var zero = FieldElement(BigInt.zero, p);
  // var G = Point(x, y, zero, seven);
  // print((G * (nn)));

  // //https://github.com/bitcoin/bitcoin/blob/master/test/functional/test_framework/key.py
  // //https://gist.github.com/nlitsme/c9031c7b9bf6bb009e5a
  // //https://github.com/PointyCastle/pointycastle/blob/master/lib/ecc/api.dart
  // //https://github.com/nbd-wtf/dart-bip340/blob/master/lib/src/helpers.dart

  // var teste =
  //     "0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798";
  // print(teste.substring(2));

  // var teste2 = S256Field(teste);
  // print(teste2);

  // var GG = S256Point(
  //     "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
  //     "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");

  // print(GG * nn);

  // var z = "0xbc62d4b80d9e36da29c16c5d4d9f11731f36052c72401a76c23c0fb5a9b74423";
  // var r = "0x37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6";
  // var s = "0x8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec";
  // var px = "0x04519fac3d910ca7e7138f7013706f619fa8f033e6ec6e09370ea38cee6a7574";
  // var py = "0x82b51eab8c27c66e26c858a079bcdf4f1ada34cec420cafc7eac1a42216fb6c4";
  // var point = S256Point(px, py);
  // var s_inv = pow(BigInt.parse(s.substring(2), radix: 16), nn - BigInt.two, nn);
  // var u = BigInt.parse(z.substring(2), radix: 16) * s_inv % nn;
  // var v = BigInt.parse(r.substring(2), radix: 16) * s_inv % nn;
  // print((GG * u + point * v).x.number);
  // print((BigInt.parse(r.substring(2), radix: 16).toString()));

  // var aaa = (GG * u + point * v).x.number;
  // var bbb = (BigInt.parse(r.substring(2), radix: 16));
  // print(aaa == bbb);

  // print(randomBigInt());
  // var bytesss = utf8.encode("sample");

  // var digesttt = sha1.convert(bytesss);
  // print(bytesss);
  // print(digesttt);

  // Deterministic K;

  // var bytessss = utf8.encode("sample");
  // var digesttt = sha256.convert(bytessss);
  // print(hex.encode(digesttt.bytes)); //zz
  // BigInt zz = BigInt.parse(hex.encode(digesttt.bytes), radix: 16);
  // //print(zz.toRadixString(16)); //zz

  // // BigInt zz = BigInt.parse(
  // //     '79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798',
  // //     radix: 16);
  // BigInt secret =
  //     BigInt.parse('09A4D6792295A7F730FC3F2B49CBC0F62E862272F', radix: 16);

  // var listK = List.generate(32, (index) => '00');
  // var k = listK.map((item) => int.parse(item, radix: 16)).toList();

  // var listV = List.generate(32, (index) => '01');
  // var v = listV.map((item) => int.parse(item, radix: 16)).toList();

  // if (zz > nn) {
  //   print('oi');
  //   print(nn);
  //   zz -= nn;
  // }

  // var z_bytes = digesttt.bytes; //hex.decode(zz.toRadixString(16));
  // var secret_bytes = [0] + hex.decode(secret.toRadixString(16)); // TODO

  // print(hex.encode(z_bytes)); //h1
  // var h1 = BigInt.parse(hex.encode(z_bytes), radix: 16);
  // print(hex.encode(encodeBigInt(secret))); //int2octets(x)
  // //print(hex.encode(secret_bytes)); //private key x

  // print(hex
  //     .encode(bits2octets(Uint8List.fromList(z_bytes), nn))); //bits2octets(h1)

  // var bits2octetsh1 = bits2octets(Uint8List.fromList(z_bytes), nn);

  // print(v);
  // print(k);

  // var hmacSha256 = Hmac(sha256, k); // HMAC-SHA256
  // k = hmacSha256.convert(v + [0] + encodeBigInt(secret) + bits2octetsh1).bytes;

  // print(hex.encode(k)); //K after step d

  // //print(hex.encode(k));
  // hmacSha256 = Hmac(sha256, k);
  // v = hmacSha256.convert(v).bytes;
  // print(hex.encode(v)); // V after step e:
  // k = hmacSha256.convert(v + [1] + encodeBigInt(secret) + bits2octetsh1).bytes;
  // print(hex.encode(k)); //K after step f
  // hmacSha256 = Hmac(sha256, k);
  // v = hmacSha256.convert(v).bytes;
  // print(hex.encode(v)); // V after step g:

  // var t = Uint8List((nn.bitLength * 1 + 7) ~/ 8);
  // print(t);

  // while (true) {
  //   v = hmacSha256.convert(v).bytes;
  //   print(hex.encode(v)); // V first try

  //   var k1 = bitsToInt(Uint8List.fromList(v), nn);
  //   print(k1.toRadixString(16));
  //   if (k1 >= BigInt.one && k1 < nn) {
  //     break;
  //   }
  //   k = hmacSha256.convert(v + [0]).bytes;
  //   print(hex.encode(k)); //new K
  //   hmacSha256 = Hmac(sha256, k);
  //   v = hmacSha256.convert(v).bytes;
  //   print(hex.encode(v)); // new V
  // }

  // do {
  //   var t = Uint8List((nn.bitLength + 7) ~/ 8);

  //   v = hmacSha256.convert(v).bytes;
  //   var candidate = BigInt.parse(hex.encode(v), radix: 16);
  //   if (candidate >= BigInt.one && candidate < nn) {
  //     print(candidate);
  //     break;
  //   }
  //   k = hmacSha256.convert(v + [0]).bytes;
  //   hmacSha256 = Hmac(sha256, k);
  //   v = hmacSha256.convert(v).bytes;
  // } while (true);

  //https://stackoverflow.com/questions/41354115/difficulty-understanding-the-example-in-rfc-6979
  //https://github.com/SixtantIO/rfc6979
  //https://github.com/bcgit/pc-dart/blob/master/lib/signers/ecdsa_signer.dart
  //https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/ecc.py
  //https://www.rfc-editor.org/rfc/rfc6979

  // BigInt secret = BigInt.parse('09A4D6792295A7F730FC3F2B49CBC0F62E862272F',
  //     radix: 16); // private key

  // var message = utf8.encode("sample");
  // var digest = sha256.convert(message);
  // BigInt z = BigInt.parse(hex.encode(digest.bytes), radix: 16);

  // var result =
  //     deterministicK(z, secret, "0x4000000000000000000020108A2E0CC0D99F8A5EF");

  // https://suragch.medium.com/working-with-bytes-in-dart-6ece83455721
  // https://stackoverflow.com/questions/65376533/dart-typeddata-and-big-little-endian-representation
  // int x = 0x80;
  // print(x);

  // String hex = 2020.toRadixString(16).padLeft(4, '0');
  // print(hex); // 07e4
  // String binary = 2020.toRadixString(2);
  // print(binary); // 11111100100

  // int myInt = int.parse('07e4', radix: 16);
  // print(myInt); // 2020
  // myInt = int.parse('11111100100', radix: 2);
  // print(myInt); // 2020

  // Uint8List byteList = Uint8List.fromList([0, 1, 2, 3]);
  // ByteData byteData = ByteData.sublistView(byteList);
  // int value = byteData.getUint16(0, Endian.little);
  // print(value); // 256

  // var string = '80'; //0x80
  // print(0x80); //128
  // print(int.parse(string, radix: 16)); //128
  // print(int.parse("0x$string")); //128

  // var pk = PrivateKey(BigInt.from(5002));
  // var point = pk.point;
  // point.address(compressed: false, testnet: true);
}
