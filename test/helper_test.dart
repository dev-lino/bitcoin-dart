import 'package:bitcoin_dart/src/helper.dart';
import 'package:test/test.dart';

void main() {
  group('Helper', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Pow', () {
      expect(pow(BigInt.from(5), BigInt.from(8), BigInt.from(4)),
          equals(BigInt.one));
      expect(pow(BigInt.from(13), BigInt.from(7), BigInt.from(31)),
          equals(BigInt.from((22))));
    });
  });
}
