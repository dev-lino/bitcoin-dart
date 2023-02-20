import 'package:equatable/equatable.dart';
import 'dart:math' as math;
import 'helper.dart';

class FieldElement extends Equatable {
  final num number;
  final num prime;

  FieldElement(this.number, this.prime) {
    if (number >= prime || number < 0) {
      String error = "Num $number not in field range 0 to ${prime - 1}";
      throw FormatException(error);
    }
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

  FieldElement operator *(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot multiply two numbers in different fields";
      throw FormatException(error);
    }
    // num and other.num are the actual values
    // prime is what we need to mod against
    var result = (number * other.number) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }

  FieldElement operator ^(int exponent) {
    var n = exponent % (prime - 1);
    var result = pow(number, n, prime);
    return FieldElement(result, prime);
  }

  FieldElement operator /(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot divide two numbers in different fields";
      throw FormatException(error);
    }
    // use Fermat's little theorem:
    // self.num**(p-1) % p == 1
    // this means:
    // 1/n == pow(n, p-2, p)
    var result = (number * pow(other.number, prime - 2, prime)) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }
}

class Point extends Equatable {
  final num? x;
  final num? y;
  final num a;
  final num b;

  Point(this.x, this.y, this.a, this.b) {
    if (x == null && y == null) return;
    if (math.pow(y!, 2) != math.pow(x!, 3) + a * x! + b) {
      String error = "($x, $y) is not on the curve";
      throw FormatException(error);
    }
  }

  @override
  String toString() {
    if (x == null) {
      return "Point(infinity)";
    } else {
      return "Point($x,$y)_${a}_$b";
    }
  }

  // toDouble function prevents Point(2, -5, 5, 7) == Point(2.0, -5.0, 5, 7)
  // equals to false
  @override
  List<Object?> get props =>
      [a.toDouble(), b.toDouble(), x?.toDouble(), y?.toDouble()];

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
      num s = (other.y! - y!) / (other.x! - x!);
      num resultX = math.pow(s, 2) - x! - other.x!;
      num resultY = s * (x! - resultX) - y!;
      return Point(resultX, resultY, a, b);
    }

    // Case 4: if we are tangent to the vertical line,
    // we return the point at infinity
    // note instead of figuring out what 0 is for each type
    // we just use 0 * self.x
    if (Point(x, y, a, b) == other && y == 0 * x!) {
      return Point(null, null, a, b);
    }

    // Case 3: self == other
    // Formula (x3,y3)=(x1,y1)+(x1,y1)
    // s=(3*x1**2+a)/(2*y1)
    // x3=s**2-2*x1
    // y3=s*(x1-x3)-y1
    if (Point(x, y, a, b) == other) {
      num s = (3 * math.pow(x!, 2) + a) / (2 * y!);
      num resultX = math.pow(s, 2) - 2 * x!;
      num resultY = s * (x! - resultX) - y!;
      return Point(resultX, resultY, a, b);
    }
    // Unexpected case
    throw FormatException();
  }
}
