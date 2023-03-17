import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

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

//bits2octets(h1)
Uint8List bits2octets(Uint8List number, BigInt n) {
  var z1 = bitsToInt(number, n);
  var z2 = z1 - n;
  return encodeBigInt(z2 < BigInt.zero ? z1 : z2);
}

Uint8List asUnsignedByteArray(BigInt value) {
  var bytes = encodeBigInt(value);

  if (bytes[0] == 0) {
    return Uint8List.fromList(bytes.sublist(1));
  } else {
    return Uint8List.fromList(bytes);
  }
}

//bits2int
BigInt bitsToInt(Uint8List t, BigInt n) {
  var v = decodeBigIntWithSign(1, t);
  if ((t.length * 8) > n.bitLength) {
    v = v >> ((t.length * 8) - n.bitLength);
  }

  return v;
}

//int2octets(x)
// Encode a BigInt into bytes using big-endian encoding.
/// It encodes the integer to a minimal twos-compliment integer as defined by
/// ASN.1
var _byteMask = BigInt.from(0xff);
final negativeFlag = BigInt.from(0x80);

Uint8List encodeBigInt(BigInt? number) {
  if (number == BigInt.zero) {
    return Uint8List.fromList([0]);
  }

  int needsPaddingByte;
  int rawSize;

  if (number! > BigInt.zero) {
    rawSize = (number.bitLength + 7) >> 3;
    needsPaddingByte =
        ((number >> (rawSize - 1) * 8) & negativeFlag) == negativeFlag ? 1 : 0;
  } else {
    needsPaddingByte = 0;
    rawSize = (number.bitLength + 8) >> 3;
  }

  final size = rawSize + needsPaddingByte;
  var result = Uint8List(size);
  for (var i = 0; i < rawSize; i++) {
    result[size - i - 1] = (number! & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

BigInt deterministicK(BigInt z, BigInt secret, String N) {
  //print(z.toRadixString(16));
  // var bytes = utf8.encode("foobar");
  // var digest = sha1.convert(bytes);
  // print(bytes);
  // print(digest);
  // BigInt zz = BigInt.parse(hex.encode(digesttt.bytes), radix: 16);
  var zz = z;
  //var n = "4000000000000000000020108A2E0CC0D99F8A5EF";
  //var nn = BigInt.parse(n, radix: 16);
  var nn = BigInt.parse(N.substring(2), radix: 16);

  var listK = List.generate(32, (index) => '00');
  var k = listK.map((item) => int.parse(item, radix: 16)).toList();

  var listV = List.generate(32, (index) => '01');
  var v = listV.map((item) => int.parse(item, radix: 16)).toList();

  // if (zz > nn) {
  //   print('oi');
  //   print(nn);
  //   zz -= nn;
  // }

  // var z_bytes = digesttt.bytes; //hex.decode(zz.toRadixString(16));
  var zBytes = hex.decode(zz.toRadixString(16)); //zz ou z?
  //var secret_bytes = [0] + hex.decode(secret.toRadixString(16));

  //print(hex.encode(z_bytes)); //h1 ok
  //var h1 = BigInt.parse(hex.encode(z_bytes), radix: 16);
  //print(hex.encode(encodeBigInt(secret))); //int2octets(x) ok
  //print(hex.encode(secret_bytes)); //private key x

  // print(hex.encode(
  // bits2octets(Uint8List.fromList(z_bytes), nn))); //bits2octets(h1) ok

  var bits2octetsh1 = bits2octets(Uint8List.fromList(zBytes), nn);

  //print(v);
  //print(k);

  var hmacSha256 = Hmac(sha256, k); // HMAC-SHA256
  k = hmacSha256.convert(v + [0] + encodeBigInt(secret) + bits2octetsh1).bytes;

  //print(hex.encode(k)); //K after step d

  //print(hex.encode(k));
  hmacSha256 = Hmac(sha256, k);
  v = hmacSha256.convert(v).bytes;
  //print(hex.encode(v)); // V after step e:
  k = hmacSha256.convert(v + [1] + encodeBigInt(secret) + bits2octetsh1).bytes;
  //print(hex.encode(k)); //K after step f
  hmacSha256 = Hmac(sha256, k);
  v = hmacSha256.convert(v).bytes;
  //print(hex.encode(v)); // V after step g:

  //var t = Uint8List((nn.bitLength * 1 + 7) ~/ 8);
  //print(t);

  while (true) {
    v = hmacSha256.convert(v).bytes;
    //print(hex.encode(v)); // V first try

    var k1 = bitsToInt(Uint8List.fromList(v), nn);
    //print(k1.toRadixString(16));
    if (k1 >= BigInt.one && k1 < nn) {
      return k1;
    }
    k = hmacSha256.convert(v + [0]).bytes;
    //print(hex.encode(k)); //new K
    hmacSha256 = Hmac(sha256, k);
    v = hmacSha256.convert(v).bytes;
    //print(hex.encode(v)); // new V
  }
}
