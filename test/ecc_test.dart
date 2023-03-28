import 'dart:typed_data';

import 'package:bitcoin_dart/bitcoin_dart.dart';
import 'package:test/test.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

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
              hexToBigInt(z), Signature(hexToBigInt(r), hexToBigInt(s))),
          isTrue);

      z = "0x7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d";
      r = "0xeff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c";
      s = "0xc7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6";
      expect(
          point.verify(
              hexToBigInt(z), Signature(hexToBigInt(r), hexToBigInt(s))),
          isTrue);
    });

    test('SEC Uncompressed/Compressed Format', () {
      var pk = PrivateKey(BigInt.from(5000));
      var point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '04ffe558e388852f0120e46af2d1b370f85854a8eb0841811ece0e3e03d282d57c315dc72890a4f10a1481c031b03b351b0dc79901ca18a00cf009dbdb157a1d10')); //hex

      pk = PrivateKey(BigInt.from(2018).pow(5));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '04027f3da1918455e03c46f659266a1bb5204e959db7364d2f473bdf8f0a13cc9dff87647fd023c13b4a4994f17691895806e1b40b57f4fd22581a4f46851f3b06')); //hex

      pk = PrivateKey(hexToBigInt('deadbeef12345'));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '04d90cd625ee87dd38656dd95cf79f65f60f7273b67d3096e68bd81e4f5342691f842efa762fd59961d0e99803c61edba8b3e3f7dc3a341836f97733aebf987121')); //hex

      pk = PrivateKey(BigInt.from(5001));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '0357a4f368868a8a6d572991e484e664810ff14c05c0fa023275251151fe0e53d1')); //hex

      pk = PrivateKey(BigInt.from(2019).pow(5));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '02933ec2d2b111b92737ec12f1c5d20f3233a0ad21cd8b36d0bca7a0cfa5cb8701')); //hex

      pk = PrivateKey(hexToBigInt('deadbeef54321'));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '0296be5b1292f6c856b3c5654e886fc13511462059089cdf9c479623bfcbe77690')); //hex

      pk = PrivateKey(BigInt.from(999).pow(3));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9')); //hex
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5')); //hex

      pk = PrivateKey(BigInt.from(123));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b')); //hex
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5'));

      pk = PrivateKey(BigInt.from(42424242));
      point = pk.point;
      expect(
          hex.encode(pk.point.sec(compressed: false)),
          equals(
              '04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3')); //hex
      expect(
          hex.encode(pk.point.sec(compressed: true)),
          equals(
              '03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e'));
    });

    test('Address', () {
      var pk = PrivateKey(BigInt.from(5002));
      var point = pk.point;
      expect(point.address(compressed: false, testnet: true),
          equals('mmTPbXQFxboEtNRkwfh6K51jvdtHLxGeMA')); //hex

      pk = PrivateKey(BigInt.from(2020).pow(5));
      point = pk.point;
      expect(point.address(compressed: true, testnet: true),
          equals('mopVkxp8UhXqRYbCYJsbeE1h1fiF64jcoH')); //hex

      pk = PrivateKey(hexToBigInt('12345deadbeef'));
      point = pk.point;
      expect(point.address(compressed: true, testnet: false),
          equals('1F1Pn2y6pDb68E5nYJJeba4TLg2U7B6KF1')); //hex
    });

    test('Create Testnet Address', () {
      //Create a testnet address for yourself using a long secret that only
      //you know. This is important as there are bots on testnet trying to
      //steal testnet coins. Make sure you write this secret down somewhere!
      //You will be using it later to sign transactions.
      var passphrase = 'jimmy@programmingblockchain.com my secret';
      var hash = hash256(Uint8List.fromList(utf8.encode(passphrase)));
      var secret = little_endian_to_int(hash);
      var pk = PrivateKey(secret);
      expect(pk.point.address(compressed: true, testnet: true),
          equals('mft9LRNtaBNtpkknB8xgm17UvPedZ4ecYL')); //hex
    });
  });

  group('PrivateKey', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Sign', () {
      //https://stackoverflow.com/questions/66118748/how-do-i-get-a-random-bigint-in-a-specific-range-dart
      var pk = PrivateKey(randomBigInt()); // procurar casos que dá erro
      var z = randomBigInt(); // procurar casos que dá erro
      var sig = pk.sign(z);
      expect(pk.point.verify(z, sig), isTrue);
    });

    test('Wif', () {
      var pk = PrivateKey(BigInt.from(5003));
      expect(pk.wif(true, true),
          equals('cMahea7zqjxrtgAbB7LSGbcQUr1uX1ojuat9jZodMN8rFTv2sfUK')); //hex

      pk = PrivateKey(BigInt.from(2021).pow(5));
      expect(pk.wif(false, true),
          equals('91avARGdfge8E4tZfYLoxeJ5sGBdNJQH4kvjpWAxgzczjbCwxic')); //hex

      pk = PrivateKey(hexToBigInt('54321deadbeef'));
      expect(pk.wif(true, false),
          equals('KwDiBf89QgGbjEhKnhXJuH7LrciVrZi3qYjgiuQJv1h8Ytr2S53a')); //hex
    });
  });

  group('Signature', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('DER', () {
      var r =
          "0x37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6";
      var s =
          "0x8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec";
      var sig = Signature(hexToBigInt(r), hexToBigInt(s));
      expect(
          hex.encode(sig.der()),
          equals(
              '3045022037206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c60221008ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec'));
    });
  });
}
