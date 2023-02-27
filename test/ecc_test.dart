import 'package:bitcoin_dart/bitcoin_dart.dart';
import 'package:bitcoin_dart/src/ecc.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('FieldElement', () {
    var a = FieldElement(2, 31);
    var b = FieldElement(2, 31);
    var c = FieldElement(15, 31);

    setUp(() {
      // Additional setup goes here.
    });

    test('Invalid', () {
      expect(() => FieldElement(13, 13), throwsFormatException);
      expect(() => FieldElement(-1, 13), throwsFormatException);
    });

    test('Print', () {
      expect(a.toString(), equals("FieldElement_31(2)"));
    });

    test('Equal', () {
      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('Not Equal', () {
      expect(a != c, isTrue);
      expect(a != b, isFalse);
    });

    test('Addition', () {
      var a = FieldElement(2, 31);
      var b = FieldElement(15, 31);
      expect(a + b, equals(FieldElement(17, 31)));
      var c = FieldElement(17, 31);
      var d = FieldElement(21, 31);
      expect(c + d, equals(FieldElement(7, 31)));
    });

    test('Subtraction', () {
      var a = FieldElement(29, 31);
      var b = FieldElement(4, 31);
      expect(a - b, equals(FieldElement(25, 31)));
      var c = FieldElement(15, 31);
      var d = FieldElement(30, 31);
      expect(c - d, equals(FieldElement(16, 31)));
    });

    test('Multiplication', () {
      var a = FieldElement(24, 31);
      var b = FieldElement(19, 31);
      expect(a * b, equals(FieldElement(22, 31)));
    });

    test('Scalar Multiplication', () {
      var a = FieldElement(24, 31);
      expect(a * 2, equals(a + a));
    });

    test('Exponentiation', () {
      var a = FieldElement(17, 31);
      expect(a ^ 3, equals(FieldElement(15, 31)));
      var b = FieldElement(5, 31);
      var c = FieldElement(18, 31);
      expect((b ^ 5) * c, equals(FieldElement(16, 31)));
    });

    test('Division', () {
      var a = FieldElement(3, 31);
      var b = FieldElement(24, 31);
      expect(a / b, equals(FieldElement(4, 31)));
      var c = FieldElement(17, 31);
      expect(c ^ -3, equals(FieldElement(29, 31)));
      var d = FieldElement(4, 31);
      var e = FieldElement(11, 31);
      expect((d ^ -4) * e, equals(FieldElement(13, 31)));
    });
  });

  group('Point', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Invalid', () {
      expect(() => Point(-1, -2, 5, 7), throwsFormatException);
    });

    test('Print', () {
      var a = Point(-1, -1, 5, 7);
      expect(a.toString(), equals("Point(-1,-1)_5_7"));
      var b = Point(null, null, 5, 7);
      expect(b.toString(), equals("Point(infinity)"));
    });

    test('Equal', () {
      var a = Point(3, -7, 5, 7);
      var b = Point(18, 77, 5, 7);
      expect(a == a, isTrue);
      expect(a == b, isFalse);
    });

    test('Not Equal', () {
      var a = Point(3, -7, 5, 7);
      var b = Point(18, 77, 5, 7);
      expect(a != b, isTrue);
      expect(a != a, isFalse);
    });

    test('Addition 0', () {
      var a = Point(-1, -1, 5, 7);
      var b = Point(-1, 1, 5, 7);
      var inf = Point(null, null, 5, 7);
      expect(a + inf, equals(a));
      expect(inf + b, equals(b));
      expect(a + b, equals(inf));
    });

    test('Addition 1', () {
      var a = Point(null, null, 5, 7);
      var b = Point(2, 5, 5, 7);
      var c = Point(2, -5, 5, 7);
      expect(a + b, equals(b));
      expect(b + a, equals(b));
      expect(b + c, equals(a));
    });

    test('Addition 2', () {
      var a = Point(3, 7, 5, 7);
      var b = Point(-1, -1, 5, 7);
      expect(a + b, equals(Point(2, -5, 5, 7)));
    });

    test('Addition 3', () {
      var a = Point(-1, -1, 5, 7);
      expect(a + a, equals(Point(18, 77, 5, 7)));
    });
  });

  group('Elliptic Curves Cryptography (ECC)', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Test On Curve', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);
      var validPoints = [
        [192, 105],
        [17, 56],
        [1, 193]
      ];
      var invalidPoints = [
        [200, 119],
        [42, 99]
      ];
      for (final point in validPoints) {
        var x = FieldElement(point[0], prime);
        var y = FieldElement(point[1], prime);
        Point(x, y, a, b);
      }

      for (final point in invalidPoints) {
        var x = FieldElement(point[0], prime);
        var y = FieldElement(point[1], prime);
        expect(() => Point(x, y, a, b), throwsFormatException);
      }
    });

    test('Point Addition Over Finite Fields', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);

      var additions = [
        //x1, y1, x2, y2, x3, y3
        [192, 105, 17, 56, 170, 142],
        [47, 71, 117, 141, 60, 139],
        [143, 98, 76, 66, 47, 71],
        [170, 142, 60, 139, 220, 181],
        [47, 71, 17, 56, 215, 68],
      ];

      for (final add in additions) {
        var p1 = Point(
            FieldElement(add[0], prime), FieldElement(add[1], prime), a, b);
        var p2 = Point(
            FieldElement(add[2], prime), FieldElement(add[3], prime), a, b);
        var p3 = Point(
            FieldElement(add[4], prime), FieldElement(add[5], prime), a, b);
        expect(p1 + p2, equals(p3));
      }
    });

    test('Scalar Multiplication Over Finite Fields', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);

      var multiplications = [
        //coefficient, x1, y1, x2, y2
        [2, 192, 105, 49, 71],
        [2, 143, 98, 64, 168],
        [2, 47, 71, 36, 111],
        [4, 47, 71, 194, 51],
        [8, 47, 71, 116, 55],
        [21, 47, 71, null, null],
      ];

      for (final mul in multiplications) {
        num coeff = mul[0] as num;

        var p1 = Point(
            FieldElement(mul[1]!, prime), FieldElement(mul[2]!, prime), a, b);

        if (mul[3] == null) {
          var p2 = Point(null, null, a, b);
          expect(p1 * coeff, equals(p2));
        } else {
          var p2 = Point(
              FieldElement(mul[3]!, prime), FieldElement(mul[4]!, prime), a, b);
          expect(p1 * coeff, equals(p2));
        }
      }
    });
  });

  group('S256Point', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Order', () {
      var G = S256Point(
          "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
          "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");
      var n = BigInt.parse(N.substring(2), radix: 16);
      var point = G * n;
      expect(point.x, isNull);
    });

    test('Public Point', () {
      // write a test that tests the public point for the following
      var G = S256Point(
          "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
          "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");
      // secret, x, y
      var points = [
        [
          7,
          "0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc",
          "0x6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da"
        ],
        [
          1485,
          "0xc982196a7466fbbbb0e27a940b6af926c1a74d5ad07128c82824a11b5398afda",
          "0x7a91f9eae64438afb9ce6448a1c133db2d8fb9254e4546b6f001637d50901f55"
        ],
        [
          BigInt.two.pow(128),
          "0x8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da",
          "0x662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82"
        ],
        [
          BigInt.two.pow(240) + BigInt.two.pow(31),
          "0x9577ff57c8234558f293df502ca4f09cbc65a6572c842b39b366f21717945116",
          "0x10b49c67fa9365ad7b90dab070be339a1daf9052373ec30ffae4f72d5e66d053"
        ],
      ];

      for (final p in points) {
        var secret = p[0];
        if (p[0] is num) {
          secret = BigInt.from(p[0] as num);
        }
        var x = p[1];
        var y = p[2];

        var point = S256Point(x, y);
        expect(G * secret, point);
      }
    });

    test('Verify', () {
      var point = S256Point(
          "0x887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c",
          "0x61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34");
      var z =
          "0xec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60";
      var r =
          "0xac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395";
      var s =
          "0x68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4";
      expect(
          point.verify(
              BigInt.parse(z.substring(2), radix: 16),
              Signature(BigInt.parse(r.substring(2), radix: 16),
                  BigInt.parse(s.substring(2), radix: 16))),
          isTrue);
      z = "0x7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d";
      r = "0xeff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c";
      s = "0xc7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6";
      expect(
          point.verify(
              BigInt.parse(z.substring(2), radix: 16),
              Signature(BigInt.parse(r.substring(2), radix: 16),
                  BigInt.parse(s.substring(2), radix: 16))),
          isTrue);
    });
  });

  group('Elliptic Curves Cryptography (ECC)', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Test On Curve', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);
      var validPoints = [
        [192, 105],
        [17, 56],
        [1, 193]
      ];
      var invalidPoints = [
        [200, 119],
        [42, 99]
      ];
      for (final point in validPoints) {
        var x = FieldElement(point[0], prime);
        var y = FieldElement(point[1], prime);
        Point(x, y, a, b);
      }

      for (final point in invalidPoints) {
        var x = FieldElement(point[0], prime);
        var y = FieldElement(point[1], prime);
        expect(() => Point(x, y, a, b), throwsFormatException);
      }
    });

    test('Point Addition Over Finite Fields', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);

      var additions = [
        //x1, y1, x2, y2, x3, y3
        [192, 105, 17, 56, 170, 142],
        [47, 71, 117, 141, 60, 139],
        [143, 98, 76, 66, 47, 71],
        [170, 142, 60, 139, 220, 181],
        [47, 71, 17, 56, 215, 68],
      ];

      for (final add in additions) {
        var p1 = Point(
            FieldElement(add[0], prime), FieldElement(add[1], prime), a, b);
        var p2 = Point(
            FieldElement(add[2], prime), FieldElement(add[3], prime), a, b);
        var p3 = Point(
            FieldElement(add[4], prime), FieldElement(add[5], prime), a, b);
        expect(p1 + p2, equals(p3));
      }
    });

    test('Scalar Multiplication Over Finite Fields', () {
      var prime = 223;
      var a = FieldElement(0, prime);
      var b = FieldElement(7, prime);

      var multiplications = [
        //coefficient, x1, y1, x2, y2
        [2, 192, 105, 49, 71],
        [2, 143, 98, 64, 168],
        [2, 47, 71, 36, 111],
        [4, 47, 71, 194, 51],
        [8, 47, 71, 116, 55],
        [21, 47, 71, null, null],
      ];

      for (final mul in multiplications) {
        num coeff = mul[0] as num;

        var p1 = Point(
            FieldElement(mul[1]!, prime), FieldElement(mul[2]!, prime), a, b);

        if (mul[3] == null) {
          var p2 = Point(null, null, a, b);
          expect(p1 * coeff, equals(p2));
        } else {
          var p2 = Point(
              FieldElement(mul[3]!, prime), FieldElement(mul[4]!, prime), a, b);
          expect(p1 * coeff, equals(p2));
        }
      }
    });
  });

  group('S256Point', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Order', () {
      var G = S256Point(
          "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
          "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");
      var n = BigInt.parse(N.substring(2), radix: 16);
      var point = G * n;
      expect(point.x, isNull);
    });

    test('Public Point', () {
      // write a test that tests the public point for the following
      var G = S256Point(
          "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
          "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");
      // secret, x, y
      var points = [
        [
          7,
          "0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc",
          "0x6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da"
        ],
        [
          1485,
          "0xc982196a7466fbbbb0e27a940b6af926c1a74d5ad07128c82824a11b5398afda",
          "0x7a91f9eae64438afb9ce6448a1c133db2d8fb9254e4546b6f001637d50901f55"
        ],
        [
          BigInt.two.pow(128),
          "0x8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da",
          "0x662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82"
        ],
        [
          BigInt.two.pow(240) + BigInt.two.pow(31),
          "0x9577ff57c8234558f293df502ca4f09cbc65a6572c842b39b366f21717945116",
          "0x10b49c67fa9365ad7b90dab070be339a1daf9052373ec30ffae4f72d5e66d053"
        ],
      ];

      for (final p in points) {
        var secret = p[0];
        if (p[0] is num) {
          secret = BigInt.from(p[0] as num);
        }
        var x = p[1];
        var y = p[2];

        var point = S256Point(x, y);
        expect(G * secret, point);
      }
    });

    test('Verify', () {
      var point = S256Point(
          "0x887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c",
          "0x61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34");
      var z =
          "0xec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60";
      var r =
          "0xac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395";
      var s =
          "0x68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4";
      expect(
          point.verify(
              BigInt.parse(z.substring(2), radix: 16),
              Signature(BigInt.parse(r.substring(2), radix: 16),
                  BigInt.parse(s.substring(2), radix: 16))),
          isTrue);
      z = "0x7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d";
      r = "0xeff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c";
      s = "0xc7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6";
      expect(
          point.verify(
              BigInt.parse(z.substring(2), radix: 16),
              Signature(BigInt.parse(r.substring(2), radix: 16),
                  BigInt.parse(s.substring(2), radix: 16))),
          isTrue);
    });
  });

  group('PrivateKey', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Sign', () {
      // /https://stackoverflow.com/questions/66118748/how-do-i-get-a-random-bigint-in-a-specific-range-dart
      var rng = Random();
      //var pk = PrivateKey(BigInt.from(rng.nextInt(256)));
      //var z = BigInt.from(rng.nextInt(256));
      var pk = PrivateKey(randomBigInt()); // procurar casos que dá erro
      var z = randomBigInt(); // procurar casos que dá erro
      var sig = pk.sign(z);
      expect(pk.point?.verify(z, sig), isTrue);
    });
  });
}
