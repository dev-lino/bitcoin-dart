import 'dart:convert';
import 'dart:typed_data';

import 'package:bitcoin_dart/src/helper.dart';
import 'package:pointycastle/export.dart';
import 'package:test/test.dart';
import 'package:convert/convert.dart';

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
      var digest = SHA256Digest().process(Uint8List.fromList(message));
      //var digest = sha256.convert(message);
      BigInt z = BigInt.parse(hex.encode(digest), radix: 16);

      expect(
          deterministicK(
              z,
              secret,
              BigInt.parse('4000000000000000000020108A2E0CC0D99F8A5EF',
                  radix: 16)),
          equals(BigInt.parse('23AF4074C90A02B3FE61D286D5C87F425E6BDD81B',
              radix: 16)));
    });
  });

  group('Base58', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Encode', () {
      var h =
          '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d';
      var bytes = hex.decode(h);
      expect(base58_encode(bytes),
          equals('9MA8fRQrT4u8Zj8ZRd6MAiiyaxb2Y1CMpvVkHQu5hVM6'));

      h = 'eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c';
      bytes = hex.decode(h);
      expect(base58_encode(bytes),
          equals('4fE3H2E6XMp4SsxtwinF7w9a34ooUrwWe4WsW1458Pd'));

      h = 'c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6';
      bytes = hex.decode(h);
      expect(base58_encode(bytes),
          equals('EQJsjkd6JaGwxrjEhfeqPenqHwrBmPQZjJGNSCHBkcF7'));
    });
  });

  group('Little Endian', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('to BigInt', () {
      var h = '99c3980000000000';
      var bytes = hex.decode(h);
      expect(little_endian_to_int(Uint8List.fromList(bytes)),
          BigInt.from(10011545));

      h = 'a135ef0100000000';
      bytes = hex.decode(h);
      expect(little_endian_to_int(Uint8List.fromList(bytes)),
          BigInt.from(32454049));
    });

    test('from BigInt', () {
      var n = BigInt.one;
      var want = [0x01, 0x00, 0x00, 0x00];
      expect(int_to_little_endian(4, n), equals(want));

      n = BigInt.from(10011545);
      want = [0x99, 0xc3, 0x98, 0x00, 0x00, 0x00, 0x00, 0x00];
      expect(int_to_little_endian(8, n), equals(want));
    });
  });
}
