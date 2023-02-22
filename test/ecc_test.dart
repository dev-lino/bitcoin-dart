import 'package:bitcoin_dart/src/ecc.dart';
import 'package:test/test.dart';

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
}
