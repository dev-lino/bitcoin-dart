import 'package:equatable/equatable.dart';

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
    var add = (num + other.num) % prime;
    // We return an element of the same class
    return FieldElement(add, prime);
  }

  FieldElement operator -(FieldElement other) {
    if (prime != other.prime) {
      String error = "Cannot subtract two numbers in different fields";
      throw FormatException(error);
    }
    // num and other.num are the actual values
    // prime is what we need to mod against
    var sub = (num - other.num) % prime;
    // We return an element of the same class
    return FieldElement(sub, prime);
  }
}
