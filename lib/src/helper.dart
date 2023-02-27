import 'dart:math';
import 'dart:typed_data';

/// Fast exponentiation (x ^ y) % n
// https://www.youtube.com/watch?v=-3Lt-EwR_Hw
// https://github.com/gkcs/Competitive-Programming/blob/master/src/main/java/main/java/videos/FastExponentiation.java
BigInt pow(BigInt x, BigInt y, BigInt n) {
  if (y == BigInt.zero) {
    return BigInt.one;
  } else {
    var R = pow(x, y ~/ BigInt.two, n);
    if (y % BigInt.two == BigInt.zero) {
      return (R * R) % n;
    } else {
      return (R * x * R) % n;
    }
  }
}

// https://stackoverflow.com/questions/66118748/how-do-i-get-a-random-bigint-in-a-specific-range-dart
BigInt randomBigInt() {
  const size = 32;
  final random = Random.secure();
  final builder = BytesBuilder();
  for (var i = 0; i < size; ++i) {
    builder.addByte(random.nextInt(256));
  }
  final bytes = builder.toBytes();
  return decodeBigIntWithSign(1, bytes);
}

/// Decode a BigInt from bytes in big-endian encoding.
/// Twos compliment.
BigInt decodeBigInt(List<int> bytes) {
  var negative = bytes.isNotEmpty && bytes[0] & 0x80 == 0x80;

  BigInt result;

  if (bytes.length == 1) {
    result = BigInt.from(bytes[0]);
  } else {
    result = BigInt.zero;
    for (var i = 0; i < bytes.length; i++) {
      var item = bytes[bytes.length - i - 1];
      result |= (BigInt.from(item) << (8 * i));
    }
  }
  return result != BigInt.zero
      ? negative
          ? result.toSigned(result.bitLength)
          : result
      : BigInt.zero;
}

/// Decode a big integer with arbitrary sign.
/// When:
/// sign == 0: Zero regardless of magnitude
/// sign < 0: Negative
/// sign > 0: Positive
BigInt decodeBigIntWithSign(int sign, List<int> magnitude) {
  if (sign == 0) {
    return BigInt.zero;
  }

  BigInt result;

  if (magnitude.length == 1) {
    result = BigInt.from(magnitude[0]);
  } else {
    result = BigInt.from(0);
    for (var i = 0; i < magnitude.length; i++) {
      var item = magnitude[magnitude.length - i - 1];
      result |= (BigInt.from(item) << (8 * i));
    }
  }

  if (result != BigInt.zero) {
    if (sign < 0) {
      result = result.toSigned(result.bitLength);
    } else {
      result = result.toUnsigned(result.bitLength);
    }
  }
  return result;
}
