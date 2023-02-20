/// Fast exponentiation (x ^ y) % n
// https://www.youtube.com/watch?v=-3Lt-EwR_Hw
// https://github.com/gkcs/Competitive-Programming/blob/master/src/main/java/main/java/videos/FastExponentiation.java
num pow(num x, num y, num n) {
  if (y == 0) {
    return 1;
  } else {
    var R = pow(x, y ~/ 2, n);
    if (y % 2 == 0) {
      return (R * R) % n;
    } else {
      return (R * x * R) % n;
    }
  }
}
