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
}
