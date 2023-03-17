import 'dart:convert';

import 'package:bitcoin_dart/src/helper.dart';
import 'package:test/test.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

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

  group('DeterministicK', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('RFC6979', () {
      BigInt secret =
          BigInt.parse('09A4D6792295A7F730FC3F2B49CBC0F62E862272F', radix: 16);

      var message = utf8.encode("sample");
      var digest = sha256.convert(message);
      BigInt z = BigInt.parse(hex.encode(digest.bytes), radix: 16);

      expect(
          deterministicK(
              z, secret, "0x4000000000000000000020108A2E0CC0D99F8A5EF"),
          equals(BigInt.parse('23AF4074C90A02B3FE61D286D5C87F425E6BDD81B',
              radix: 16)));
    });
  });
}
