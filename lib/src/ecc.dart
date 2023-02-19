import 'package:equatable/equatable.dart';
import 'helper.dart';

class FieldElement extends Equatable {
  final int num;
  final int prime;

  FieldElement(this.num, this.prime) {
    if (num >= prime || num < 0) {
      String error = "Num $num not in field range 0 to ${prime - 1}";
      throw FormatException(error);
    }
  }

  @override
  String toString() {
    return "FieldElement_$prime($num)";
  }

  @override
  List<Object> get props => [num, prime];

  FieldElement operator +(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot add two numbers in different fields";
      throw FormatException(error);
    }
    // num and other.num are the actual values
    // prime is what we need to mod against
    var result = (num + other.num) % prime;
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
    var result = (num - other.num) % prime;
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
    var result = (num * other.num) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }

  FieldElement operator ^(int exponent) {
    var n = exponent % (prime - 1);
    var result = pow(num, n, prime);
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
    var result = (num * pow(other.num, prime - 2, prime)) % prime;
    // We return an element of the same class
    return FieldElement(result, prime);
  }
}
