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

    test('Add', () {
      var a = FieldElement(2, 31);
      var b = FieldElement(15, 31);
      expect(a + b, equals(FieldElement(17, 31)));
      var c = FieldElement(17, 31);
      var d = FieldElement(21, 31);
      expect(c + d, equals(FieldElement(7, 31)));
    });

    test('Sub', () {
      a = FieldElement(29, 31);
      b = FieldElement(4, 31);
      expect(a - b, equals(FieldElement(25, 31)));
      var c = FieldElement(15, 31);
      var d = FieldElement(30, 31);
      expect(c - d, equals(FieldElement(16, 31)));
    });
  });
}
