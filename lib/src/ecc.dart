import 'package:equatable/equatable.dart';

import 'helper.dart';

//ignore: must_be_immutable
class FieldElement extends Equatable {
  dynamic number;
  dynamic prime;

  FieldElement(dynamic number, dynamic prime) {
    var number_ = number;
    var prime_ = prime;
    if (number is num) {
      number_ = BigInt.from(number);
      prime_ = BigInt.from(prime);
    }
    if (number_ >= prime_ || number_ < BigInt.zero) {
      String error =
          "Num $number_ not in field range 0 to ${prime_ - BigInt.one}";
      throw FormatException(error);
    }
    this.number = number_;
    this.prime = prime_;
  }

  @override
  String toString() {
    return "FieldElement_$prime($number)";
  }

  @override
  List<Object> get props => [number, prime];

  FieldElement operator +(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot add two numbers in different fields";
      throw FormatException(error);
    }
    // num and other.num are the actual values
    // prime is what we need to mod against
    var result = (number + other.number) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }

  FieldElement operator -(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot subtract two numbers in different fields";
      throw FormatException(error);
    }
    // num and other.num are the actual values
    // prime is what we need to mod against
    var result = (number - other.number) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }

  FieldElement operator *(dynamic other) {
    if (other is FieldElement) {
      // Multiplication of two FieldElements
      if (prime != other.prime) {
        String error = "Cannot multiply two numbers in different fields";
        throw FormatException(error);
      }
      var operand = other.number;
      // num and other.num are the actual values
      // prime is what we need to mod against
      var result = (number * operand) % prime;
      // We return an element of the same class
      return FieldElement(result, prime);
    } else {
      // Scalar Multiplication (other is the coefficient)
      var operand_ = other;
      if (operand_ is num) {
        operand_ = BigInt.from(other);
      }
      var result = (number * operand_) % prime;
      return FieldElement(result, prime);
    }
  }

  FieldElement operator ^(int exponent) {
    var exponent_ = BigInt.from(exponent);
    var n = exponent_ % (prime - BigInt.one);
    var result = pow(number, n, prime);
    return FieldElement(result, prime);
  }

  FieldElement operator /(FieldElement other) {
    var number_ = number;
    var prime_ = prime;
    var otherNumber_ = other.number;
    if (number is num) {
      number_ = BigInt.from(number);
      prime_ = BigInt.from(prime);
      otherNumber_ = BigInt.from(other.number);
    }
    if (prime != other.prime) {
      String error = "Cannot divide two numbers in different fields";
      throw FormatException(error);
    }
    // use Fermat's little theorem:
    // self.num**(p-1) % p == 1
    // this means:
    // 1/n == pow(n, p-2, p)
    var result =
        (number_ * pow(otherNumber_, prime_ - BigInt.two, prime_)) % prime_;
    // We return an element of the same class
    return FieldElement(result, prime_);
  }
}

//ignore: must_be_immutable
class Point extends Equatable {
  dynamic x; // parameters could be of type num or ElementField
  dynamic y;
  dynamic a;
  dynamic b;

  Point(this.x, this.y, this.a, this.b) {
    if (x == null && y == null) return;
    if (y! * y! != (x! * x!) * x! + a * x! + b) {
      String error = "($x, $y) is not on the curve";
      throw FormatException(error);
    }
  }

  @override
  String toString() {
    if (x == null) {
      return "Point(infinity)";
    } else if (x is FieldElement) {
      return "Point(${x.number},${y.number})_${a.number}_${b.number} FieldElement(${x.prime})";
    } else {
      return "Point($x,$y)_${a}_$b";
    }
  }

  @override
  List<Object?> get props {
    // if x is FieldElement or point at infinity (x == null)
    if (x is FieldElement || x == null) {
      return [x, y, a, b];
    } else {
      // toDouble function prevents Point(2, -5, 5, 7) == Point(2.0, -5.0, 5, 7)
      // equals to false
      return [a.toDouble(), b.toDouble(), x?.toDouble(), y?.toDouble()];
    }
  }

  Point operator +(Point other) {
    if (a != other.a || b != other.b) {
      String error =
          "Points Point($x,$y)_${a}_$b, ${other.toString()} are not on the same curve";
      throw FormatException(error);
    }
    // Case 0.0: first point is at infinity, return other
    if (x == null) return other;
    // Case 0.1: other point is at infinity, return first
    if (other.x == null) return Point(x, y, a, b);

    // Case 1: x == other.x, y != other.y
    // Result is point at infinity
    if (x == other.x && y != other.y) return Point(null, null, a, b);

    // Case 2: x != other.x
    // Formula (x3,y3)==(x1,y1)+(x2,y2)
    // s=(y2-y1)/(x2-x1)
    // x3=s**2-x1-x2
    // y3=s*(x1-x3)-y1
    if (x != other.x) {
      dynamic s = (other.y! - y!) / (other.x! - x!);
      dynamic resultX = s * s - x! - other.x!;
      dynamic resultY = s * (x! - resultX) - y!;
      return Point(resultX, resultY, a, b);
    }

    // Case 4: if we are tangent to the vertical line,
    // we return the point at infinity
    // note instead of figuring out what 0 is for each type
    // we just use 0 * self.x
    if (Point(x, y, a, b) == other && y == x! * 0) {
      return Point(null, null, a, b);
    }

    // Case 3: self == other
    // Formula (x3,y3)=(x1,y1)+(x1,y1)
    // s=(3*x1**2+a)/(2*y1)
    // x3=s**2-2*x1
    // y3=s*(x1-x3)-y1
    if (Point(x, y, a, b) == other) {
      dynamic s = ((x! * x!) * 3 + a) / (y! * 2);
      dynamic resultX = s * s - x! * 2;
      dynamic resultY = s * (x! - resultX) - y!;
      return Point(resultX, resultY, a, b);
    }
    // Unexpected case
    String error = "Unexpected case on point addition routine";
    throw FormatException(error);
  }

  Point operator *(dynamic other) {
    // A naive implementation
    // var product = Point(null, null, a, b);
    // for (int i = 0; i < other; i++) {
    //   product = product + Point(x, y, a, b);
    // }
    // return product;

    // Binary expansion implementation
    dynamic zero = 0;
    dynamic one = 1;
    if (other is BigInt) {
      zero = BigInt.zero;
      one = BigInt.one;
    }
    var coef = other;
    var current = Point(x, y, a, b);
    var result = Point(null, null, a, b);
    while (coef != zero) {
      if (coef & one != zero) {
        result = result + current;
      }
      current = current + current;
      coef = coef >> 1;
    }
    return result;
  }
}

const String A = "0x0";
const String B = "0x7";
const String P =
    "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F";
const String N =
    "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141";

//ignore: must_be_immutable
class S256Field extends FieldElement {
  S256Field(dynamic number)
      : super(BigInt.parse(number.substring(2), radix: 16),
            BigInt.parse(P.substring(2), radix: 16));

  @override
  String toString() {
    return (number as BigInt).toRadixString(16).padLeft(64, '0');
  }
}

//ignore: must_be_immutable
class S256Point extends Point {
  static var paramA = S256Field(A);
  static var paramB = S256Field(B);
  static var G = S256Point(
      "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
      "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");

  S256Point._internal(dynamic x, dynamic y, dynamic a, dynamic b)
      : super(x, y, a, b);

  factory S256Point.fromPoint(Point p) {
    if (p.x == null) {
      return S256Point._internal(p.x, p.y, paramA, paramB);
    } else {
      return S256Point._internal(S256Field("0x${p.x.number.toRadixString(16)}"),
          S256Field("0x${p.y.number.toRadixString(16)}"), p.a, p.b);
    }
  }

  factory S256Point(dynamic x, dynamic y) {
    if (x == null) {
      return S256Point._internal(x, y, paramA, paramB);
    } else {
      return S256Point._internal(S256Field(x), S256Field(y), paramA, paramB);
    }
  }

  @override
  List<Object> get props => [x, y, a, b];

  @override
  S256Point operator *(dynamic other) {
    var n = BigInt.parse(N.substring(2), radix: 16);
    var coef = other % n;
    var result = super * (coef);
    return S256Point.fromPoint(result);
  }

  bool verify(BigInt z, Signature sig) {
    var n = BigInt.parse(N.substring(2), radix: 16);
    var sInv = pow(sig.s, n - BigInt.two, n);
    var u = z * sInv % n;
    var v = sig.r * sInv % n;
    var total = G * u + S256Point("0x$x", "0x$y") * v;
    return total.x.number == sig.r;
  }
}

class Signature {
  BigInt r;
  BigInt s;

  Signature(this.r, this.s);

  @override
  String toString() {
    return "Signature(${r.toRadixString(16)},${s.toRadixString(16)})";
  }
}

class PrivateKey {
  BigInt secret;
  S256Point? point;
  static var G = S256Point(
      "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
      "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8");

  PrivateKey(this.secret) {
    point = (G * secret);
  }

  @override
  String toString() {
    return (secret).toRadixString(16);
  }

  Signature sign(BigInt z) {
    var n = BigInt.parse(N.substring(2), radix: 16);
    //var rng = Random();
    //var k = BigInt.from(rng.nextInt(256)); //radint(0, N)
    //var k = randomBigInt() % n; // testar caso k = 0;
    var k = deterministicK(z, secret, N) % n;
    //var k = BigInt.zero; // dá erro
    //var k = n; // dá erro
    var r = (G * k).x.number;
    var kInv = pow(k, n - BigInt.two, n);
    var s = (z + r * secret) * kInv % n;
    return Signature(r, s);
  }
}
