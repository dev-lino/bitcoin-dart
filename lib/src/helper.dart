/// Fast exponentiation x^y % mod
/// https://www.youtube.com/watch?v=-3Lt-EwR_Hw
int pow(int x, int y, int mod) {
  if (y == 0) {
    return 1;
  } else {
    var R = pow(x, y ~/ 2, mod);
    if (y % 2 == 0) {
      return (R * R) % mod;
    } else {
      return (R * x * R) % mod;
    }
  }
}
