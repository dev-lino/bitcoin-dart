import 'package:bitcoin_dart/src/helper.dart';
import 'package:test/test.dart';

void main() {
  group('Helper', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Pow', () {
      expect(pow(5, 8, 4), equals(1));
      expect(pow(13, 7, 31), equals(22));
    });
  });
}
